class VideosController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_video, only: [:show, :update, :destroy]
  # before_action :verify_org_access!
  # before_action :check_org_status

  def index
    @channels = Channel.all.order(:name)
    @videos = Video.includes(:channel)

    if params[:query].present?
      @videos = @videos.joins(:channel).where(
        "videos.title ILIKE :q OR channels.name ILIKE :q",
        q: "%#{params[:query]}%"
      )
    end

    if params[:channel_id].present?
      @videos = @videos.where(channel_id: params[:channel_id])
    end

   @videos = @videos.accessible_by_user(current_user)
  end

  def show; end

  def new
    @channel = Channel.find(params[:channel_id])
    @video = @channel.videos.build
  end

  def create
    @channel = Channel.find(params[:channel_id])
    @video = @channel.videos.build(video_params)
    if @video.save
      redirect_to [@channel.organization, @channel, @video], notice: "Video uploaded successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def children
    @videos = Video.where("min_age <= 12")
  end

  def teen
    @videos = Video.where("min_age >= ? and min_age <= ?",12, 18)
  end

  def adult
    @videos = Video.where("min_age >= 18")
  end

  private
  def set_video
    @video = Video.find(params[:id])
  end

  def video_params
    params.require(:video).permit(:title, :description, :youtube_url, :file, :visibility, :min_age)
  end

  def verify_org_access!
    return if current_user.organizations.include?(@video.channel.organization)
    redirect_to root_path, alert: "Access denied."
  end

  def check_org_status
    @organization = @video.organization
    redirect_to root_path, alert: "Organization is not active yet." unless @organization.active?
  end
end