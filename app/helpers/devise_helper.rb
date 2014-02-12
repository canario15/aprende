module DeviseHelper

  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map{|msg| content_tag(:ul,content_tag(:label, msg)) }.join.html_safe
    content_tag :div, messages,class: 'alert alert-dismissable alert-danger'
  end

end