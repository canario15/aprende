module ApplicationHelper

  def li_ul_current_page? (title,page,li_ul_list = nil,li_ul_list_two = nil)
    if li_ul_list or li_ul_list_two
      html = (link_to page, class: "dropdown-toggle", "data-toggle" => "dropdown" do
        concat  title
        concat content_tag(:b,"",class: "caret")
      end)

      li_class = "dropdown"
      content_ui = ""

      if li_ul_list
        li_class += " active" if li_ul_list.any?{|li| current_page? li.second}
        content_ui +=  li_ul_list.map{|li| content_tag(:li, link_to(li.first,li.second,li.third)) }.join.html_safe
      end

      if li_ul_list_two
        li_class += " active" if li_ul_list_two.any?{|li| current_page? li.second}
        content_ui +=  content_tag(:li,nil, class:"divider")
        content_ui +=  li_ul_list_two.map{|li| content_tag(:li, link_to(li.first,li.second,li.third)) }.join.html_safe
      end

      html += content_tag :ul,content_ui.html_safe, class: "dropdown-menu"
    else
      html = link_to title,page
      li_class = "active" if current_page?(page)
    end
    content_tag :li ,class: li_class do
      html
    end
  end

  def flash_and_messages
    html= ""
    messages = ""
    self.instance_variable_names.each do |name|
      variable = eval(name)
      if variable.methods.include? :errors and variable.present? and variable.errors.present?
        messages = variable.errors.full_messages.map{|msg| content_tag(:ul,content_tag(:label, msg)) }.join.html_safe
      end
    end

    [{type: "resource_errors" ,message: messages, style: "danger",icon: "ban-circle"},
     {type: "alert", message: flash[:alert], style: "danger",icon: "ban-circle"},
     {type: "notice", message: flash[:notice], style: "success",icon: "ok"},].each do |item|
      if item[:message].present?
        html += content_tag :div,class: "modal alert alert-dismissable alert-#{item[:style]} general-alert" do
          link = (item[:type] == "notice") ? (link_to flash[:link][:title] ,flash[:link][:url],class: 'alert-link' if flash[:link]) : ""
          (content_tag :button,"×", class:"close","data-dismiss" => "alert", type: "button"  ) +
          (content_tag :span,nil, class: "icon-#{item[:icon]}") +
          (content_tag :label, item[:message]) +
          (link)
        end
      end
    end
    html.html_safe
  end

  def section_id(section)
    case section
    when "game"
      "services"
    when "trivium","home"
      "folio"
    when "users"
      "student"
    else
      "about"
    end
  end

  def section_title(section)
    case section
    when "game"
      icon = "gamepad"
      title = (content_tag :strong, "Juegos") + (content_tag :p, "Sobre las ".html_safe + (content_tag :span,"trivias"))
    when "trivium","home"
      icon = "book"
      title = (content_tag :strong, "Trivias") + (content_tag :p, "Elegi una para ".html_safe + (content_tag :span,"comenzar"))
    when "users"
      icon = "smile"
      title = (content_tag :strong, "Alumnos") + (content_tag :p, "Datos de ".html_safe + (content_tag :span,"Perfil"))
    else
      icon = "error"
      title = (content_tag :strong, section)
    end

    content_tag :div, class: "section-title" do
     (content_tag :i,nil,class: "icon-"+icon) +
     (title)
    end
  end

end