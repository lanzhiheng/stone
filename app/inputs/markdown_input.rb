class MarkdownInput < Formtastic::Inputs::TextInput
  def to_html
    input_wrapping do
      label_html << template.content_tag(:div, class: 'markdown-wrapper') do
        builder.text_area(method, input_html_options.merge(id: 'md_editor'))
      end
    end
  end
end
