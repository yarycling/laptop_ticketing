window.portalRedirect = function portalRedirect(url) {
  window.location.assign(url || '/');
};

window.portalSchoolCode = function portalSchoolCode(value) {
  if (value && typeof value === 'object') {
    value = value.value || value.$value || '';
  }

  return String(value || '')
    .normalize('NFKD')
    .replace(/[\u0300-\u036f]/g, '')
    .trim()
    .toUpperCase()
    .replace(/[^A-Z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
};

window.portalSetSchoolForm = function portalSetSchoolForm(school) {
  const data = school || {};
  const values = {
    schoolId: data.id || '',
    schoolName: data.name || '',
    schoolDistrict: data.district_id || '',
    schoolStatus: data.status || 'active'
  };

  Object.keys(values).forEach(function setSchoolField(id) {
    const field = document.getElementById(id);
    if (!field) return;

    field.value = values[id] == null ? '' : String(values[id]);
    field.dispatchEvent(new Event('input', { bubbles: true }));
    field.dispatchEvent(new Event('change', { bubbles: true }));
  });

  return true;
};

if (window.dmx && typeof window.dmx.Formatters === 'function') {
  window.dmx.Formatters('global', {
    portalRedirect: function portalRedirect(url) {
      window.location.assign(url || '/');
    },
    portalSchoolCode: function portalSchoolCode(value) {
      return window.portalSchoolCode(value);
    },
    portalSetSchoolForm: function portalSetSchoolForm(school) {
      return window.portalSetSchoolForm(school);
    }
  });
}
