import $ from 'jquery'

document.addEventListener('turbo:load', (event) => {
  $('#ajaxForm').submit(function(e) {
    e.preventDefault()
    var $form = $(this)
    var url = $form.attr("action");

    /* Checking the content */
    var messages = []

    $form.find('.field').each(function() {
      var $this = $(this)
      var $input = $this.find('input, textarea')
      var value = $input.val()
      if (!value) {
        var message = $this.find('label').text().slice(0, -1) + ' can not be blank.'
        messages.push(message)
      }
    })

    if (messages.length) {
      alert(messages[0])
      return
    }
    /* Checking the content */

    var $btn = $('.btn')
    $btn.addClass('disabled')
    var cached = $btn.html()
    $btn.html('Sending...')

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
      },
      success: function() {
        alert('Sent Successfully')
        window.location.href = '/'
      },
      error: function(data) {
        alert(data.responseJSON.msg)
      },
      complete: function(data) {
        $btn.removeClass('disabled')
        $btn.html(cached)
        $form.find('input, textarea').val('') // clean up all data
      }
    })
  })
})
