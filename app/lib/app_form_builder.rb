class AppFormBuilder < ActionView::Helpers::FormBuilder
  def field(html_class: 'field')
    @template.content_tag(:div, yield.html_safe, class: html_class)
  end

  def simple(field_type, attribute, html_class: 'field')
    label_tag = label(attribute)
    field_tag = send(field_type, attribute)
    content = @template.safe_join([label_tag, field_tag])
    field { content }
  end
end
