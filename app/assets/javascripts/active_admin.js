//= require active_admin/base
//= require easymde.min.js
//= require select2/dist/js/select2.js
//= require_self

$(document).ready(function() {
  var easyMDE = new EasyMDE({
    element: document.getElementById('md_editor'),
    spellChecker: false
  });

  var tagListInput = $('#post_tag_list').select2({
    tags: true,
    data: [
      {
        id: 'enhancement',
        text: 'enhancement'
      },
      {
        id: 'bug',
        text: 'bug'
      },
      {
        id: 'wontfix',
        text: 'wontfix'
      }
    ]
  })
})
