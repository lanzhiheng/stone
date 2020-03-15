//= require active_admin/base
//= require easymde.min.js
//= require_self

window.addEventListener('DOMContentLoaded', (event) => {
  var easyMDE = new EasyMDE({
    element: document.getElementById('md_editor'),
    spellChecker: false
  });
})
