class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.super_admin?
      load_super_admin_dashboard
    elsif current_user.admin?
      load_admin_dashboard
    else
      redirect_to videos_path
    end
  end

  private

  def load_super_admin_dashboard
    @total_videos        = Video.count
    @total_channels      = Channel.count
    @total_organizations = Organization.count
    @total_users         = User.count
    @total_members       = Membership.count


    @child_videos = Video.where('min_age <= 12').count
    @teen_videos  = Video.where(min_age: 13..17).count
    @adult_videos = Video.where('min_age >= 18').count
  end

  def load_admin_dashboard
    organizations = current_user.organizations

    @total_channels = 0
    @total_videos   = 0
    @total_members  = 0
    @child_videos   = 0
    @teen_videos    = 0
    @adult_videos   = 0

    organizations.each do |org|
      channels = org.channels
      users    = org.memberships
      videos   = Video.joins(:channel).where(channels: { organization_id: org.id })

      @total_channels += channels.count
      @total_videos   += videos.count
      @total_members  += users.count

      @child_videos += videos.where('min_age <= 12').count
      @teen_videos  += videos.where(min_age: 13..17).count
      @adult_videos += videos.where('min_age >= 18').count
    end
  end
end
