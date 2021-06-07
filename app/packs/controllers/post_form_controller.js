import { Controller } from "stimulus"
import EasyMDE from 'easymde/dist/easymde.min'

export default class extends Controller {

  static targets = [ "categorySelector", "markdownTextArea", "tagListSelector" ]

  connect() {
    this.markdownInitialization()
    this.selectorInitialization()
  }

  disconnect() {
    this.destryMarkdown()
    this.destrySelectors()
  }

  destryMarkdown() {
    this.easyMDE.toTextArea();
    this.easyMDE = null;
  }

  destrySelectors() {
    $(this.categorySelectorTarget).select2('destroy')
    $(this.tagListSelectorTarget).select2('destroy')
  }

  selectorInitialization() {
    $(this.categorySelectorTarget).select2()
    $(this.tagListSelectorTarget).select2({
      tags: true
    })
  }

  markdownInitialization() {
    const element = this.categorySelectortarget
    const that = this
    that.easyMDE = new EasyMDE({
      element: element,
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
            that.easyMDE.codemirror.replaceSelection(textToInsert)
          },
          error: function(data) {
            alert(data.responseJSON.msg)
          }
        })
      }
    });
  }
}
