module ApplicationHelper
  def menu_item (page,icon,title)
    active = (current_page? page) ? 'active' : ""
    panel  = content_tag(:span, title, class: 'panel-title hide')
    link_to( content_tag(:span, panel, class: "icon-"+icon, title: title), page, class: "section-home section-link-left "+  active)
  end

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
    style=""
    self.instance_variable_names.each do |name|
      variable = eval(name)
      if variable.methods.include? :errors and variable.present? and variable.errors.present?
        messages = variable.errors.full_messages.map{|msg| content_tag(:span,content_tag(:label, msg), class: "icon-ban-circle row")}.join
        style = "danger"
      end
    end

    if flash[:notice].present?
      notice = ( flash[:notice] )
      notice += (link_to flash[:link][:title] ,flash[:link][:url],class: 'alert-link') if flash[:link]

      messages += content_tag(:span,content_tag(:label, notice.html_safe), class: "icon-ok row")
      style = "success"
    end

    if flash[:alert].present?
      messages += content_tag(:span,content_tag(:label, flash[:alert]), class: "icon-ban-circle row")
      style = "danger"
    end

    if messages.present?
      html += content_tag :div,class: "modal alert alert-dismissable alert-#{style} general-alert" do
       (content_tag :button,"×", class:"close","data-dismiss" => "alert", type: "button"  ) +
       (messages.html_safe)
      end
    end

    html.html_safe
  end

  def section_id
    case controller_path
    when "game"
      "services"
    when "trivium","home"
      "folio"
    when "users","users/registrations"
      "student"
    when "teachers","teachers/registrations"
      "blog"
    when "institutes"
      "contact"
    else
      "about"
    end
  end

  def section_title
    case controller_path
    when "game"
      icon = "gamepad"
      title = (content_tag :strong, "Resultados") + (content_tag :p, "Sobre las ".html_safe + (content_tag :span,"trivias"))
    when "trivium","home"
      icon = "book"
      if teacher_signed_in?
        title = (content_tag :strong, "Mis Trivias") + (content_tag :p, "Gestiona las ".html_safe + (content_tag :span,"trivias"))
      else
        title = (content_tag :strong, "Trivias") + (content_tag :p, "Elegi una para ".html_safe + (content_tag :span,"comenzar"))
      end
    when "institutes"
      icon = "building"
      title = (content_tag :strong, "Áreas") + (content_tag :p, "Para ".html_safe + (content_tag :span,"Capacitar"))
    when "users","users/registrations"
      icon = "smile"
      title = (content_tag :strong, "Personas") + (content_tag :p, "Datos del ".html_safe + (content_tag :span,"Perfil"))
    when "teachers","teachers/registrations"
      icon = "briefcase"
      title = (content_tag :strong, "Instructores") + (content_tag :p, "Datos del ".html_safe + (content_tag :span,"Perfil"))
    when "courses"
      icon = "book"
      title = (content_tag :strong, "Capacitaciones") + (content_tag :p, "Para ".html_safe + (content_tag :span,"Exponer"))
    else
      icon = "error"
      title = (content_tag :strong, controller_path)
    end

    content_tag :div, class: "section-title" do
     (content_tag :i,nil,class: "icon-"+icon) +
     (title)
    end
  end

  def modal_content(content)
    if content
      content_tag :div, class: "modalDialog", id: "modal"+content.id.to_s do
        content_tag :div do
          html = link_to "x","#close", class: "modal-close"
          case content.containable_type
          when "Pdf"
            html+= content_tag :object, nil, type: "application/pdf", width: "100%", height: "400px", data: content.containable.document
          when "Written"
            html+= text_area_tag "text-area-modal"+content.id.to_s,content.containable.document, disabled: :true
          end
          html.html_safe
        end
      end
    end
  end

  def button_modal_content(content)
    if content
      content_tag :p, (link_to "Ver Contenido","#modal"+content.id.to_s, class: "button-modal")
    end
  end
end