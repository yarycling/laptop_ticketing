# Phase 4D Excel Device Import

## Production Workflow

The production device-import format is XLSX only. Authorized users download a fresh workbook from `GET /api/device-imports/template`; its manufacturer, model, and condition lookup values are generated from the current active catalogue. `POST /api/device-imports/upload` accepts `.xlsx` workbooks only. CSV upload is no longer supported through the production UI or API.

The workbook contains a `Device Import` sheet and a `Lookups` sheet. The `Lookups` sheet is `veryHidden`. The import sheet provides dropdowns for active manufacturers, manufacturer-dependent models, and active conditions. Date cells are formatted and validated as dates. The workbook supports at most 5,000 device rows and the upload is limited to 10 MB.

Workbook validation is a user aid, not a trust boundary. The uploaded workbook is untrusted input; Server Connect validates parsed values against the current database catalogue and device records. Upload stages rows only. Validation creates no devices. Commit rechecks applicable data and creates the complete batch all-or-nothing.

Historical CSV-origin batches remain readable through the normal batch list, detail, and row APIs. Their history and audit records are retained; this does not make CSV a supported production upload format.

## Excel Adapter Boundary

The approved `device_xlsx` Server Connect adapter is a narrow infrastructure exception using ExcelJS solely for XLSX workbook generation and parsing. It handles workbook sheets, lookup data, named ranges, formatting, validations, and values. It does not access the database, authorize users, make business decisions, manage batch state, create devices, or manage transactions. Wappler Server Connect remains responsible for application authorization, validation, staging, and all writes.
