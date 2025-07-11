class ChannelsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_channel, only: %i[show edit update destroy]
  before_action :check_org_status, only: %i[show edit update]
  before_action :require_admin, only: %i[edit show update destroy]

  def index
    @channels = Channel.includes(:user, :organization).all
  end

  def show; end

  def new
    @channel = Channel.new
  end

  def create
    @channel = current_user.channels.build(channel_params)
    if @channel.save
      redirect_to @channel, notice: 'Channel was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @channel.update(channel_params)
      redirect_to @channel, notice: 'Channel was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @channel.destroy
    redirect_to channels_path, notice: 'Channel was successfully deleted.'
  end

  private

  def set_channel
    @channel = Channel.find(params[:id])
  end

  def channel_params
    params.require(:channel).permit(:name, :description, :organization_id)
  end

  def check_org_status
    @organization = @channel.organization
    unless @organization.active?
      redirect_to root_path, alert: "Organization is not active yet."
    end
  end

  def require_admin
    unless current_user&.admin? || current_user&.super_admin?
      redirect_to root_path, alert: "Access denied"
    end
  end
end
