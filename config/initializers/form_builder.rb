class ActionView::Helpers::FormBuilder
  def fields_for_contents
    html_contents = fields_for :content, @object.contents_init do |ff|
      containable_type_class = {class: "hidden hidden_field_#{ff.object.containable_type }"}
      containable_type_class[:value] = "" unless (ff.object.containable.present? and ff.object.containable.document.present?)
      div_class = ""
      div_id= ""
      html = ff.fields_for :containable do |fff|
        div_class = fff.object.document.present? ? "show" : "hidden"
        div_id = "div_containable_#{fff.object.class.name}"
        case fff.object.class.name
          when "Pdf"
            (@template.link_to fff.object.document_file_name,fff.object.document.url) +
            (fff.file_field :document)
          when "Written"
            fff.text_area :document, :class => 'ckeditor'
        end
      end
      (ff.text_field :containable_type, containable_type_class) +
      (@template.content_tag(:div,html, {id: div_id, class: div_class }))
    end

    selected =  if (@object.content.present? and @object.content.containable.present? and @object.content.containable.document.present?)
      @object.content.containable_type
    else
      nil
    end
    html_contents = (@template.content_tag(:div,html_contents,class: "col-lg-10 col-lg-offset-2"))

    select_options = {prompt: "Elige un contenido",disabled: 'restricted',  selected: selected }
    html_select=(@template.select :contents,:containable_type, Content::TYPE,select_options, { class: "contents_selection form-control"})

    html_select = (@template.content_tag(:label, "Contenido", class: "col-lg-2 control-label"))+
    (@template.content_tag(:div,html_select,class: "col-lg-10"))


    (@template.content_tag(:div,html_select,class:"form-group"))+
    (@template.content_tag(:div,html_contents,class:"form-group"))
  end
end
ActionView::Base.field_error_proc = Proc.new{ |html_tag, instance| "<span class=\"field_with_errors\">#{html_tag}</span>".html_safe }
