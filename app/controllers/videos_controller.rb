class VideosController < ApplicationController
  before_action :authenticate_user!

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
end