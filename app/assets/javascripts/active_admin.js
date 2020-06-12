//= require arctic_admin/base
//= require easymde.min.js
// To avoid CSRF token authenticity issue https://guides.rubyonrails.org/security.html#cross-site-request-forgery-csrf
//= require rails-ujs
//= require select2/dist/js/select2.js
//= require_self

$(document).ready(function() {
  var easyMDE = new EasyMDE({
    element: document.getElementById('md_editor'),
    spellChecker: false,
    uploadImage: true,
    imageUploadFunction: function(file) {
      var formData = new FormData()
      formData.append('file', file)

      $.ajax({
        processData: false,
        contentType: false,
        url: '/upload',
        method: 'PUT',
        data: formData,
        success: function(data) {
          const { name, url } = data
          const textToInsert = `![${name}](${url})`
          easyMDE.codemirror.replaceSelection(textToInsert)
        },
        error: function(data) {
          alert(data.responseJSON.msg)
        }
      })
    }
  });

  $('#post_tag_list').select2({
    tags: true
  })
})
