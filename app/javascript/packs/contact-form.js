import $ from 'jquery'
import Push from 'push.js'

document.addEventListener('turbolinks:load', (event) => {
  $('#ajaxForm').submit(function(e) {
    e.preventDefault()
    var $form = $(this)
    var url = $form.attr("action");

    var $btn = $('.btn')
    $btn.addClass('disabled')
    var cached = $btn.html()
    $btn.html('发送中...')

    var messages = []

    $form.find('.field').each(function() {
      var $this = $(this)
      var $input = $this.find('input, textarea')
      var value = $input.val()
      if (!value) {
        var message = $this.find('label').text().slice(0, -1) + '不能为空。'
        messages.push(message)
      }
    })

    if (messages.length) alert(messages[0])

    $.ajax({
      method: "POST",
      url: url,
      contentType: "multipart/form-data",
      dataType: "json",
      data: new FormData(this),
      processData: false,
      contentType: false,
      headers: {
        "Accept": "application/json"
      }
    }).done(function() {
      Push.create("Notification", {
        link: '',
        body: 'Sent Successfully',
        onClick: function () {
          window.focus();
          this.close();
        }
      });
      $btn.removeClass('disabled')
      $btn.html(cached)
      $form.find('input, textarea').val('') // clean up all data
    })
  })
})
