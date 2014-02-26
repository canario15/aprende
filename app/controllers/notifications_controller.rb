class NotificationsController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @notifications = Notification.active_all
  end

  def new
    @notification = Notification.new
  end

  def create
    @notification = Notification.new(notification_params)
    respond_to do |format|
      if @notification.save
        format.html { redirect_to notifications_path, notice: 'Notificacion creada.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def logic_delete
    @notification = Notification.find(params[:notification_id])
    @notification.inactivate
    respond_to do |format|
      if @notification.save
        format.json { render json: { result: true, active: @notification.active} }
      else
        format.json { render json: { result: false, active: @notification.active } }
      end
    end
  end

  def notification_params
    params.require(:notification).permit(:title, :description)
  end
end
