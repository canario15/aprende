class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, :only => [:new, :create, :cancel]
  prepend_before_filter :authenticate_scope!, :only => [:edit, :update, :destroy]
  before_filter :configure_permitted_parameters, :if => :devise_controller?

  def registrations_types
    render 'user_type'
  end

  def artist_settings
    authorize! :new_artist_data, :profile
    render 'artist_settings'
  end

  def artist_payment
    begin
      current_user.payment_transaction(params[:stripeToken])
      unless current_user.provider && current_user.parent_data.nil?
        current_user.send_confirmation_instructions
      end
      current_user.update_attributes(:step => Constants::STEP[:profile_preferences])
      flash[:notice] = t 'messages.notices.payment_success'
      redirect_to new_artist_profile_path
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to '/artist_settings'
    rescue Stripe::InvalidRequestError => e
      flash[:error] = e.message
      redirect_to '/artist_settings'
    rescue Stripe::AuthenticationError => e
      flash[:error] = e.message
      redirect_to '/artist_settings'
    rescue Stripe::APIConnectionError => e
      flash[:error] = e.message
      redirect_to '/artist_settings'
    rescue Stripe::StripeError => e
      flash[:error] = e.message
      redirect_to '/artist_settings'
    rescue
      flash[:error] = t 'messages.errors.paymen_unsuccessful'
      redirect_to '/artist_settings'
    end
  end

  # GET /resource/sign_up
  def new
    if session['devise.omniauth']
      session.delete('devise.omniauth')
      user = User.where(:email => Omniauth::Helper.email_user_attributes(session)).first
      if user.provider.blank?
        flash[:error] = t "messages.errors.user_exists_without_social_account", email: Omniauth::Helper.email_user_attributes(session)
      else
        flash[:error] = t "messages.errors.user_exists_other_social_account", email: Omniauth::Helper.email_user_attributes(session)
      end
    end
    Omniauth::Helper.delete_user_attributes session
    build_resource({})
    respond_with(self.resource) do |format|
      if is_an_artist?
        format.html { render 'new_artist' }
      else
        format.html { render 'new_fan' }
      end
    end
  end

  def sign_in_social_network
    user = User.where(provider: Omniauth::Helper.provider(session), uid: Omniauth::Helper.uid(session)).first
    Omniauth::Helper.delete_user_attributes session
    Omniauth::Helper.delete_user_type session
    build_resource({})
    self.resource = user
    sign_in(resource_name, resource)
    respond_with(resource, :location => after_sign_up_path_for(resource)) do |format|
      format.html { redirect_to after_sign_up_path_for(resource)}
    end
  end

  def sign_up_social_network
    if Omniauth::Helper.user_attributes session
      user = User.where(provider: Omniauth::Helper.provider(session), uid: Omniauth::Helper.uid(session)).first
      if user
        Omniauth::Helper.delete_user_attributes session
        Omniauth::Helper.delete_user_type session
        build_resource({})
        if is_an_artist?
          user.create_artist
          user.save
        end
        self.resource = user
        sign_in(resource_name, resource)
        flash[:notice] = t "messages.notices.linked_social_account", provider: resource.provider.capitalize
        respond_with(self.resource) do |format|
          if is_an_artist?
            format.html { render 'new_artist' }
          else
            format.html { render 'new_fan' }
          end
        end
      else
        Omniauth::Helper.delete_user_attributes session
        redirect_to new_user_registration_path(user_type: params[:user_type])
      end
    elsif current_user
      build_resource({})
      self.resource = current_user
      respond_with(self.resource) do |format|
        if is_an_artist?
          format.html { render 'new_artist' }
        else
          format.html { render 'new_fan' }
        end
      end
    else
      Omniauth::Helper.delete_user_attributes session
      redirect_to new_user_registration_path(user_type: params[:user_type])
    end
  end

  # POST /resource
  def create
    unless params[:birthday].blank?
      birthday = params[:birthday]
      params[:user][:birthday] = DateTime.new(birthday[:year].to_i, birthday[:month].to_i, birthday[:day].to_i)
    end
    build_resource(sign_up_params)
    if is_an_artist?
      resource.is_artist = true
      resource.skip_confirmation!
      resource.step = Constants::STEP[:settings]
    else
      resource.step = Constants::STEP[:profile_preferences]
    end

    begin
      if resource.save
        set_flash_message :notice, :signed_up if is_navigational_format?
        if !resource.is_artist
          confirmation_token = resource.confirmation_token
          resource.confirm!
          resource.confirmation_token = confirmation_token
          resource.save
        else
          parent_submit = parent_params.merge(user_id: resource.id)
          if has_parent_control? parent_submit
            parentData = ParentData.create(parent_submit)
          end
        end
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        clean_up_passwords resource
        respond_with(self.resource) do |format|
          if is_an_artist?
            format.html { render 'new_artist' }
          else
            format.html { render 'new_fan' }
          end
        end
      end
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
    end
  end

  def new_artist_profile
    authorize! :new_artist_payment, :profile
    if current_user
      @profile = current_user.profile
      @performer_types = Admin::PerformerType.all
      @disciplines = []
      @genres =[]
      @notification = @profile.notification

      @selected_disciplines = @profile.discipline_ids
      @selected_preferences = @profile.preference_ids
      @selected_performs = @profile.perform_ids

    else
      flash[:error] = t "messages.errors.sign_in_required"
      redirect_to root_path
    end
  end

  def create_artist_profile
    @profile = Profile.find_by_user_id(current_user.id)
    if(!params[:ajaxRequest].nil? && params[:ajaxRequest] == 'true')
      manage_avatar_cropping
    else
      filter_disciplines
      filter_performs
      filter_preferences

      current_user.update_attributes(:step => Constants::STEP[:landing_page])
      confirm_changes = (!params[:must_update_avatar].nil? && params[:must_update_avatar] == 'true')
      confirm_changes_cover = (!params[:must_update_cover].nil? && params[:must_update_cover] == 'true')

      submit_params = profile_params
      submit_params.delete(:temporal_avatar)
      submit_params.delete(:temporal_photo_cover)
      coords_submit = {}
      update_coords_session coords_submit
      update_cover_coords_session coords_submit

      all_params = submit_params.merge(coords_submit)

      @profile.validates_selects = true

      if @profile.update_attributes(all_params)
          if(confirm_changes)
            @profile.avatar = @profile.temporal_avatar
            @profile.save!
            clear_coords
          end

          if confirm_changes_cover
            @profile.photo_cover = @profile.temporal_photo_cover
            @profile.save!
            clear_coords_cover
          end

          flash[:notice] = t 'messages.notice.welcome_message'

          # Check if the recently created user has pending group membership invitations
          membership = Membership.pending_membership current_user.email
          if membership
            redirect_to member_acceptance_path(token: membership.token)
          else
            redirect_to users_home_path
          end
      else
        @profile = current_user.profile
        @user = current_user
        @disciplines = []
        @notification = @profile.notification
        @performer_types = Admin::PerformerType.all
        @genres =[]

        @selected_disciplines = @profile.discipline_ids
        @selected_preferences = @profile.preference_ids
        @selected_performs = @profile.perform_ids
        render :action => 'new_artist_profile'
      end
    end

  end



  def new_fan_profile
    authorize! :new_fan_profile, :profile
    if current_user
      @profile = current_user.profile

      @performer_types = Admin::PerformerType.all

      @genres =[]
      @notification = @profile.notification

      @selected_preferences = @profile.preference_ids

    else
      flash[:error] = t "messages.errors.sign_in_required"
      redirect_to root_path
    end
  end


  def create_fan_profile

    @profile = Profile.find_by_user_id(current_user.id)
    if(!params[:ajaxRequest].nil? && params[:ajaxRequest] == 'true')
      manage_avatar_cropping
    else
      filter_preferences
      current_user.update_attributes(:step => Constants::STEP[:landing_page])
      confirm_changes = (!params[:must_update_avatar].nil? && params[:must_update_avatar] == 'true')
      confirm_changes_cover = (!params[:must_update_cover].nil? && params[:must_update_cover] == 'true')
      submit_params = profile_params
      submit_params.delete(:temporal_avatar)
      submit_params.delete(:temporal_photo_cover)
      coords_submit = {}
      update_coords_session coords_submit
      update_cover_coords_session coords_submit

      all_params = submit_params.merge(coords_submit)

      if @profile.update_attributes(all_params)
        if(confirm_changes)
          @profile.avatar = @profile.temporal_avatar
          @profile.save!
          clear_coords
        end
        if confirm_changes_cover
          @profile.photo_cover = @profile.temporal_photo_cover
          @profile.save!
          clear_coords_cover
        end
        flash[:notice] = 'Thank you and welcome!'
        redirect_to users_home_path
      else
        @profile = current_user.profile
        @user = current_user

        @notification = @profile.notification
        @performer_types = Admin::PerformerType.all
        @genres =[]

        @selected_preferences = @profile.preference_ids

        render :action => 'new_fan_profile'
      end
    end
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    unless params[:birthday].blank?
      birthday = params[:birthday]
      params[:user][:birthday] = DateTime.new(birthday[:year].to_i, birthday[:month].to_i, birthday[:day].to_i)
    end
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if update_resource(resource, account_update_params)
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
            :update_needs_confirmation : :updated
      end
      sign_in resource_name, resource, :bypass => true
      if is_an_artist?
        resource.is_artist = true
        resource.step = Constants::STEP[:settings]
      else
        resource.step = Constants::STEP[:profile_preferences]
      end
      resource.save
      if is_an_artist?
        parent_submit = parent_params.merge(user_id: resource.id)
        if has_parent_control? parent_submit
          parentData = ParentData.create(parent_submit)
        end
      end
      respond_with resource, :location => after_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      respond_with(self.resource) do |format|
        if is_an_artist?
          format.html { render 'new_artist' }
        else
          format.html { render 'new_fan' }
        end
      end
    end
  end

 def city_country_with_zip_code
    data = Admin::ZipCode.city_and_country(params[:zip_code])
    respond_to do |format|
      format.json { render json: data.to_json }
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :first_name, :last_name, :zip_code, :city, :state, :birthday, :initials, :provider, :uid) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password, :password_confirmation, :current_password, :first_name, :last_name, :zip_code, :city, :state, :birthday, :initials) }
  end

  def is_an_artist?
    params[:user_type] == 'artist'
  end

  def filter_preferences
    preferences = params[:profile][:preference_ids]
    filter_selections(preferences)
  end

  def filter_performs
    performs = params[:profile][:perform_ids]
    filter_selections(performs)
  end

  def filter_disciplines
    disciplines = params[:profile][:discipline_ids]
    filter_selections(disciplines)
  end

  def filter_selections(params)
    params.each_with_index do |p, i|
      if(i % 2 == 0)
        if params[i+1] != ''
          params[i] = ''
        end
      end
    end
  end

  def profile_params
    params.require(:profile).permit(:use_nickname, :nickname, :performer_type_id, {discipline_ids: []},
      {perform_ids: []} ,{expertise_area_ids: []}, {preference_ids: []}, :avatar, :temporal_avatar,
       :photo_cover, :photo_cover_file_name, :avatar_file_name, :avatar_content_type, :temporal_photo_cover_file_name,
       :temporal_avatar_file_name, :temporal_avatar_content_type, :photo_cover_content_type,
       :avatar_file_size, :temporal_avatar_file_size, :photo_cover_file_size,
       :avatar_updated_at, :temporal_avatar_updated_at, :photo_cover_updated_at, :temporal_photo_cover,
       :temporal_photo_cover_content_type, :temporal_photo_cover_file_size,
       :temporal_photo_cover_updated_at,
       :content, :created_at, :updated_at, :crop_x, :crop_y, :crop_h, :crop_w, :crop_cover_x, :crop_cover_y,
       :crop_cover_h, :crop_cover_w,
      notification_attributes: [:n_new_award,
      :n_private_message, :n_updates_artist_ifollow, :n_hot_new_artist_ifollow,
      :n_someone_checksout_my_demo, :n_someone_performs_my_demo, :e_new_award,
     :e_private_message, :e_updates_artist_ifollow, :e_hot_new_artist_ifollow,
     :e_someone_checksout_my_demo, :e_someone_performs_my_demo])
  end

  def coords_params
    params.permit(:crop_x, :crop_y, :crop_w, :crop_h)
  end

  def coords_params_cover
    params.permit(:crop_cover_x, :crop_cover_y, :crop_cover_w, :crop_cover_h)
  end

  def parent_params
    params.require(:parent).permit(:first_name, :last_name, :email, :phone_number, :initials)
  end

  def has_avatar_coords?
    !params[:crop_x].blank? && !params[:crop_y].blank? && !params[:crop_w].blank? && !params[:crop_h].blank?
  end

  def has_cover_coords?
    !params[:crop_cover_x].blank? && !params[:crop_cover_y].blank? && !params[:crop_cover_w].blank? && !params[:crop_cover_h].blank?
  end

  def manage_avatar_cropping
    submit_params = profile_params
    coords_submit = {}

    if (request.parameters[:must_render_modal_avatar] == 'true')
      submit_params.delete(:temporal_photo_cover)
    elsif (request.parameters[:must_render_modal_cover] == 'true')
      submit_params.delete(:temporal_avatar)
    else
      submit_params.delete(:temporal_avatar)
      submit_params.delete(:temporal_photo_cover)
      if (request.parameters[:must_render_preview] == 'true')
        coords_submit = coords_params
        update_coords coords_submit
      else
        coords_submit = coords_params_cover
        update_cover_coords coords_submit
      end
    end

    all_params = coords_submit.nil? ? submit_params : submit_params.merge(coords_submit)

    @profile.validates_selects = false
    if @profile.update_attributes(all_params)
      if has_avatar_coords?
        @profile.temporal_avatar.reprocess!
      end
      if has_cover_coords?
        @profile.temporal_photo_cover.reprocess!
      end
      if(!request.parameters[:must_render_preview].nil? && request.parameters[:must_render_preview] == 'true')
        render partial: "profile/commons/avatar_preview", layout: false, formats: [:html]
      elsif (!request.parameters[:must_render_preview_cover].nil? && request.parameters[:must_render_preview_cover] == 'true')
        render partial: "profile/commons/cover_preview", layout: false, formats: [:html]
      elsif (request.parameters[:must_render_modal_cover] == 'true')
        if !@profile.valid_file_dimensions
          flash[:notice] = 'Width must be at least 960px and height must be at least 400px'
        end
        render partial: "profile/commons/modal_picture", layout: false, formats: [:html], :locals => { avatar: false, valid_file_dimensions: @profile.valid_file_dimensions }
      else
        render partial: "profile/commons/modal_picture", layout: false, formats: [:html], :locals => { avatar: true, valid_file_dimensions: true }
      end
    else
      render partial: 'profile/commons/modal_picture', layout: false, formats: [:html], :locals => { avatar: true }
    end
  end

  def update_coords coords_submit
    if (@profile.temporal_avatar_file_name.nil?) || (@profile.temporal_avatar_geometry(:large).width == 1)
      ratio = 1
    else
      ratio = @profile.temporal_avatar_geometry(:original).width / @profile.temporal_avatar_geometry(:large).width

      coords_submit[:crop_x] = (coords_submit[:crop_x].to_i * ratio).to_s
      coords_submit[:crop_y] = (coords_submit[:crop_y].to_i * ratio).to_s
      coords_submit[:crop_w] = (coords_submit[:crop_w].to_i * ratio).to_s
      coords_submit[:crop_h] = (coords_submit[:crop_h].to_i * ratio).to_s

      session[:crop_x] = coords_submit[:crop_x]
      session[:crop_y] = coords_submit[:crop_y]
      session[:crop_w] = coords_submit[:crop_w]
      session[:crop_h] = coords_submit[:crop_h]
    end
  end

  def update_cover_coords coords_submit
    if (@profile.temporal_photo_cover_file_name.nil?) || (@profile.temporal_photo_cover_geometry(:large).width == 1)
      ratio = 1
    else
      ratio = @profile.temporal_photo_cover_geometry(:original).width / @profile.temporal_photo_cover_geometry(:large).width

      coords_submit[:crop_cover_x] = (coords_submit[:crop_cover_x].to_i * ratio).to_s
      coords_submit[:crop_cover_y] = (coords_submit[:crop_cover_y].to_i * ratio).to_s
      coords_submit[:crop_cover_w] = (coords_submit[:crop_cover_w].to_i * ratio).to_s
      coords_submit[:crop_cover_h] = (coords_submit[:crop_cover_h].to_i * ratio).to_s

      session[:crop_cover_x] = coords_submit[:crop_cover_x]
      session[:crop_cover_y] = coords_submit[:crop_cover_y]
      session[:crop_cover_w] = coords_submit[:crop_cover_w]
      session[:crop_cover_h] = coords_submit[:crop_cover_h]
    end
  end

  def update_coords_session coords_submit
    coords_submit[:crop_x] = session[:crop_x]
    coords_submit[:crop_y] = session[:crop_y]
    coords_submit[:crop_w] = session[:crop_w]
    coords_submit[:crop_h] = session[:crop_h]
  end

  def update_cover_coords_session coords_submit
    coords_submit[:crop_cover_x] = session[:crop_cover_x]
    coords_submit[:crop_cover_y] = session[:crop_cover_y]
    coords_submit[:crop_cover_w] = session[:crop_cover_w]
    coords_submit[:crop_cover_h] = session[:crop_cover_h]
  end

  def clear_coords
    session.delete :crop_x
    session.delete :crop_y
    session.delete :crop_w
    session.delete :crop_h
  end

  def clear_coords_cover
    session.delete :crop_cover_x
    session.delete :crop_cover_y
    session.delete :crop_cover_w
    session.delete :crop_cover_h
  end

  def has_parent_control? parent_submit
    !parent_submit[:initials].blank?
  end

end

