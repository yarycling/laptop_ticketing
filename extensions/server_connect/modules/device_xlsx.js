const fs = require('fs-extra');
const path = require('node:path');
const ExcelJS = require('exceljs');
const { toAppPath, toSystemPath } = require('../../../lib/core/path');

const ROW_LIMIT = 5000;
const IMPORT_HEADERS = [
  'serial_number',
  'asset_tag',
  'manufacturer_code',
  'model_code',
  'condition_code',
  'warranty_start_date',
  'warranty_end_date',
  'received_date',
  'procurement_reference',
  'supplier_name',
  'warranty_reference'
];
const ALLOWED_ROOTS = [
  path.resolve('storage/device-imports'),
  path.resolve('storage/device-import-templates')
];
const DISPLAY_SEPARATOR = '\u2014';

function displayValue(code, name) {
  return `${String(code || '').trim()} ${DISPLAY_SEPARATOR} ${String(name || '').trim()}`;
}

function assertRows(value, label) {
  if (!Array.isArray(value)) throw new Error(`XLSX adapter requires ${label} rows.`);
  return value;
}

function safeFilePath(value) {
  const fullPath = toSystemPath(value);
  const allowed = ALLOWED_ROOTS.some(root => {
    const relative = path.relative(root, fullPath);
    return relative === '' || (!relative.startsWith('..') && !path.isAbsolute(relative));
  });
  if (!allowed) throw new Error('XLSX file path is outside the approved import storage directories.');
  return fullPath;
}

function cellText(cell) {
  const value = cell.value;
  if (value == null) return { value: null, formula: false };
  if (value instanceof Date) return { value, formula: false };
  if (typeof value === 'object') {
    if (value.formula || value.sharedFormula) return { value: null, formula: true };
    if (Array.isArray(value.richText)) return { value: value.richText.map(part => part.text || '').join(''), formula: false };
    if (typeof value.text === 'string' && value.hyperlink) return { value: value.text, formula: false };
    return { value: null, formula: false };
  }
  return { value: String(value).trim() === '' ? null : value, formula: false };
}

function canonicalDate(value) {
  if (value == null || value === '') return null;
  if (value instanceof Date && !Number.isNaN(value.getTime())) {
    const year = value.getUTCFullYear();
    if (year < 1900 || year > 9999) return null;
    return [year, String(value.getUTCMonth() + 1).padStart(2, '0'), String(value.getUTCDate()).padStart(2, '0')].join('-');
  }
  if (typeof value === 'number' && Number.isFinite(value)) {
    const date = new Date(Date.UTC(1899, 11, 30) + Math.floor(value) * 86400000);
    if (!Number.isFinite(date.getTime()) || date.getUTCFullYear() < 1900 || date.getUTCFullYear() > 9999) return null;
    return [date.getUTCFullYear(), String(date.getUTCMonth() + 1).padStart(2, '0'), String(date.getUTCDate()).padStart(2, '0')].join('-');
  }
  const match = String(value).match(/^(\d{4})-(\d{2})-(\d{2})$/);
  if (match) {
    const date = new Date(Date.UTC(Number(match[1]), Number(match[2]) - 1, Number(match[3])));
    if (date.getUTCFullYear() === Number(match[1]) && date.getUTCMonth() + 1 === Number(match[2]) && date.getUTCDate() === Number(match[3])) return `${match[1]}-${match[2]}-${match[3]}`;
  }
  return null;
}

function lookupRows(sheet, firstColumn, codeColumn, idColumn) {
  const map = new Map();
  for (let rowNumber = 2; rowNumber <= sheet.rowCount; rowNumber++) {
    const display = cellText(sheet.getCell(rowNumber, firstColumn)).value;
    if (display == null) continue;
    map.set(String(display), {
      code: cellText(sheet.getCell(rowNumber, codeColumn)).value,
      id: idColumn ? Number(cellText(sheet.getCell(rowNumber, idColumn)).value) : null
    });
  }
  return map;
}

module.exports = {
  generateTemplate: async function(options) {
    const manufacturers = assertRows(this.parseRequired(options.manufacturers, 'object', 'Manufacturers are required.'), 'manufacturer');
    const models = assertRows(this.parseRequired(options.models, 'object', 'Models are required.'), 'model');
    const conditions = assertRows(this.parseRequired(options.conditions, 'object', 'Conditions are required.'), 'condition');
    const outputPath = safeFilePath(this.parseRequired(options.path, 'string', 'An output path is required.'));

    const workbook = new ExcelJS.Workbook();
    workbook.creator = 'Wappler Device Import';
    workbook.created = new Date();

    const importSheet = workbook.addWorksheet('Device Import', { views: [{ state: 'frozen', ySplit: 1 }] });
    importSheet.addRow(IMPORT_HEADERS);
    importSheet.getRow(1).font = { bold: true };
    importSheet.columns = [
      { key: 'serial_number', width: 24 }, { key: 'asset_tag', width: 20 },
      { key: 'manufacturer_code', width: 32 }, { key: 'model_code', width: 38 },
      { key: 'condition_code', width: 26 }, { key: 'warranty_start_date', width: 20 },
      { key: 'warranty_end_date', width: 20 }, { key: 'received_date', width: 20 },
      { key: 'procurement_reference', width: 24 }, { key: 'supplier_name', width: 30 },
      { key: 'warranty_reference', width: 24 }, { key: 'manufacturer_model_range', hidden: true, width: 4 }
    ];

    const lookupSheet = workbook.addWorksheet('Lookups');
    lookupSheet.addRow(['display_value', 'manufacturer_code', 'manufacturer_id', 'range_name']);
    const sortedManufacturers = [...manufacturers].sort((a, b) => String(a.name).localeCompare(String(b.name)));
    const manufacturersEnd = Math.max(2, sortedManufacturers.length + 1);
    const manufacturerRanges = [];

    sortedManufacturers.forEach((manufacturer, index) => {
      const rangeName = `MFG_${Number(manufacturer.id)}_MODELS`;
      lookupSheet.addRow([displayValue(manufacturer.manufacturer_code, manufacturer.name), manufacturer.manufacturer_code, Number(manufacturer.id), rangeName]);
      const manufacturerModels = models
        .filter(model => Number(model.manufacturer_id) === Number(manufacturer.id))
        .sort((a, b) => String(a.model_name).localeCompare(String(b.model_name)));
      const listColumn = 17 + index;
      const listHeader = rangeName;
      lookupSheet.getCell(1, listColumn).value = listHeader;
      if (manufacturerModels.length) {
        manufacturerModels.forEach((model, modelIndex) => {
          lookupSheet.getCell(modelIndex + 2, listColumn).value = displayValue(model.model_code, model.model_name);
        });
      } else {
        lookupSheet.getCell(2, listColumn).value = '';
      }
      const columnLetter = lookupSheet.getColumn(listColumn).letter;
      workbook.definedNames.add(`Lookups!$${columnLetter}$2:$${columnLetter}$${Math.max(2, manufacturerModels.length + 1)}`, rangeName);
      manufacturerRanges.push({ id: Number(manufacturer.id), rangeName });
    });

    if (!sortedManufacturers.length) lookupSheet.getCell(2, 1).value = '';
    workbook.definedNames.add(`Lookups!$A$2:$A$${manufacturersEnd}`, 'MANUFACTURER_OPTIONS');

    lookupSheet.getCell(1, 7).value = 'manufacturer_id';
    lookupSheet.getCell(1, 8).value = 'manufacturer_code';
    lookupSheet.getCell(1, 9).value = 'model_code';
    lookupSheet.getCell(1, 10).value = 'model_name';
    lookupSheet.getCell(1, 11).value = 'display_value';
    models.forEach((model, index) => {
      const manufacturer = sortedManufacturers.find(item => Number(item.id) === Number(model.manufacturer_id));
      if (manufacturer) {
        const rowNumber = index + 2;
        lookupSheet.getCell(rowNumber, 7).value = Number(model.manufacturer_id);
        lookupSheet.getCell(rowNumber, 8).value = manufacturer.manufacturer_code;
        lookupSheet.getCell(rowNumber, 9).value = model.model_code;
        lookupSheet.getCell(rowNumber, 10).value = model.model_name;
        lookupSheet.getCell(rowNumber, 11).value = displayValue(model.model_code, model.model_name);
        lookupSheet.getCell(rowNumber, 11).value = displayValue(model.model_code, model.model_name);
      }
    });

    lookupSheet.getCell(1, 14).value = 'display_value';
    lookupSheet.getCell(1, 15).value = 'condition_code';
    const sortedConditions = [...conditions].sort((a, b) => Number(a.sort_order || 0) - Number(b.sort_order || 0));
    sortedConditions.forEach((condition, index) => {
      lookupSheet.getCell(index + 2, 14).value = displayValue(condition.code, condition.name);
      lookupSheet.getCell(index + 2, 15).value = condition.code;
    });
    if (!sortedConditions.length) lookupSheet.getCell(2, 14).value = '';
    workbook.definedNames.add(`Lookups!$N$2:$N$${Math.max(2, sortedConditions.length + 1)}`, 'CONDITION_OPTIONS');

    const manufacturerLookupEnd = Math.max(2, sortedManufacturers.length + 1);
    for (let row = 2; row <= ROW_LIMIT + 1; row++) {
      importSheet.getCell(row, 12).value = {
        formula: `IFERROR(VLOOKUP(C${row},'Lookups'!$A$2:$D$${manufacturerLookupEnd},4,FALSE),"")`
      };
      for (const column of [6, 7, 8]) importSheet.getCell(row, column).numFmt = 'yyyy-mm-dd';
      importSheet.getCell(row, 3).dataValidation = { type: 'list', formulae: ['MANUFACTURER_OPTIONS'], allowBlank: true, showErrorMessage: true, errorTitle: 'Invalid manufacturer', error: 'Select an active manufacturer from the list.' };
      importSheet.getCell(row, 4).dataValidation = { type: 'list', formulae: [`INDIRECT($L${row})`], allowBlank: true, showErrorMessage: true, errorTitle: 'Invalid model', error: 'Select a model for the selected manufacturer.' };
      importSheet.getCell(row, 5).dataValidation = { type: 'list', formulae: ['CONDITION_OPTIONS'], allowBlank: true, showErrorMessage: true, errorTitle: 'Invalid condition', error: 'Select an active condition from the list.' };
      for (const column of [6, 7, 8]) {
        importSheet.getCell(row, column).dataValidation = { type: 'date', operator: 'between', formulae: [new Date(Date.UTC(1900, 0, 1)), new Date(Date.UTC(9999, 11, 31))], allowBlank: true, showErrorMessage: true, errorTitle: 'Invalid date', error: 'Enter a valid Excel date.' };
      }
    }
    lookupSheet.state = 'veryHidden';
    lookupSheet.getColumn(12).hidden = true;
    lookupSheet.getColumn(13).hidden = true;
    lookupSheet.getColumn(16).hidden = true;

    await fs.ensureDir(path.dirname(outputPath));
    await workbook.xlsx.writeFile(outputPath);
    return { path: toAppPath(outputPath), filename: 'device-import-template.xlsx', row_limit: ROW_LIMIT, manufacturer_count: sortedManufacturers.length, model_count: models.length, condition_count: sortedConditions.length, model_ranges: manufacturerRanges };
  },

  parseWorkbook: async function(options) {
    const appPath = this.parseRequired(options.path, 'string', 'An uploaded workbook path is required.');
    const filePath = safeFilePath(appPath);
    if (path.extname(filePath).toLowerCase() !== '.xlsx') throw new Error('Only .xlsx workbooks are accepted.');
    const stat = await fs.stat(filePath);
    if (!stat.isFile() || stat.size > 10 * 1024 * 1024) throw new Error('The workbook is invalid or exceeds 10 MB.');

    const workbook = new ExcelJS.Workbook();
    await workbook.xlsx.readFile(filePath);
    const sheet = workbook.getWorksheet('Device Import');
    const lookupSheet = workbook.getWorksheet('Lookups');
    if (!sheet || !lookupSheet) throw new Error('The workbook must contain Device Import and Lookups sheets.');

    const headers = IMPORT_HEADERS.map((_, index) => cellText(sheet.getCell(1, index + 1)).value);
    if (headers.some((header, index) => header !== IMPORT_HEADERS[index])) throw new Error('The Device Import sheet headers do not match the required template.');
    let hasOverflowRows = false;
    sheet.eachRow({ includeEmpty: false }, (row, rowNumber) => {
      if (rowNumber > ROW_LIMIT + 1 && IMPORT_HEADERS.some((_, index) => {
        const input = cellText(row.getCell(index + 1));
        return input.value != null || input.formula;
      })) hasOverflowRows = true;
    });
    if (hasOverflowRows) throw new Error('The workbook exceeds the 5,000 device row limit.');

    const manufacturerMap = lookupRows(lookupSheet, 1, 2, 3);
    const modelMap = new Map();
    for (let row = 2; row <= lookupSheet.rowCount; row++) {
      const manufacturerId = cellText(lookupSheet.getCell(row, 7)).value;
      const modelDisplay = cellText(lookupSheet.getCell(row, 11)).value;
      if (manufacturerId != null && modelDisplay != null) {
        modelMap.set(`${Number(manufacturerId)}\u0000${String(modelDisplay)}`, cellText(lookupSheet.getCell(row, 9)).value);
      }
    }
    const conditionMap = lookupRows(lookupSheet, 14, 15, null);
    const rows = [];
    const lastRow = Math.min(sheet.rowCount, ROW_LIMIT + 1);

    for (let rowNumber = 2; rowNumber <= lastRow; rowNumber++) {
      const values = IMPORT_HEADERS.map((_, index) => cellText(sheet.getCell(rowNumber, index + 1)));
      if (values.every(item => item.value == null && !item.formula)) continue;
      const formulaErrors = values.flatMap((item, index) => item.formula ? [`${IMPORT_HEADERS[index]} contains a formula; formula values are not read.`] : []);
      const inputErrors = [...formulaErrors];
      const [serial, asset, manufacturer, model, condition, warrantyStart, warrantyEnd, received, procurement, supplier, warrantyReference] = values.map(item => item.value);
      const manufacturerDisplay = manufacturer == null ? null : String(manufacturer);
      const manufacturerLookup = manufacturerDisplay == null ? null : manufacturerMap.get(manufacturerDisplay);
      const modelDisplay = model == null ? null : String(model);
      const conditionDisplay = condition == null ? null : String(condition);
      const modelCode = manufacturerLookup && modelDisplay != null ? modelMap.get(`${manufacturerLookup.id}\u0000${modelDisplay}`) : null;
      const conditionLookup = conditionDisplay == null ? null : conditionMap.get(conditionDisplay);
      const warrantyStartDate = canonicalDate(warrantyStart);
      const warrantyEndDate = canonicalDate(warrantyEnd);
      const receivedDate = canonicalDate(received);
      const mappingErrors = [];
      if (manufacturerDisplay && !manufacturerLookup) mappingErrors.push('Manufacturer selection could not be resolved from workbook lookup data.');
      if (modelDisplay && !modelCode) mappingErrors.push('Model selection could not be resolved for the selected manufacturer.');
      if (conditionDisplay && !conditionLookup) mappingErrors.push('Condition selection could not be resolved from workbook lookup data.');
      if (warrantyStart != null && !warrantyStartDate) inputErrors.push('warranty_start_date is not a valid date.');
      if (warrantyEnd != null && !warrantyEndDate) inputErrors.push('warranty_end_date is not a valid date.');
      if (received != null && !receivedDate) inputErrors.push('received_date is not a valid date.');

      rows.push({
        row_number: rowNumber,
        serial_number: serial,
        asset_tag: asset,
        manufacturer_display: manufacturerDisplay,
        manufacturer_code: manufacturerLookup ? manufacturerLookup.code : null,
        model_display: modelDisplay,
        model_code: modelCode || null,
        condition_display: conditionDisplay,
        condition_code: conditionLookup ? conditionLookup.code : null,
        warranty_start_date: warrantyStart == null ? null : warrantyStartDate || String(warrantyStart),
        warranty_end_date: warrantyEnd == null ? null : warrantyEndDate || String(warrantyEnd),
        received_date: received == null ? null : receivedDate || String(received),
        procurement_reference: procurement,
        supplier_name: supplier,
        warranty_reference: warrantyReference,
        formula_errors: formulaErrors,
        mapping_errors: mappingErrors,
        input_errors: inputErrors
      });
    }
    return { success: true, row_count: rows.length, rows };
  }
};
