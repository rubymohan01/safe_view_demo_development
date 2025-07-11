class Video < ApplicationRecord
  belongs_to :channel
  has_one_attached :file

  enum visibility: { everyone: 0, members_only: 1, restricted: 2 }
  scope :accessible_by_user, ->(user) {
                                        return none unless user&.age

                                        where("min_age <= ?", user.age)
                                      }

  def youtube_video_id
    return unless youtube_url.present?

    uri = URI.parse(youtube_url)
    if uri.host.include?("youtube.com")
      CGI.parse(uri.query)["v"]&.first
    elsif uri.host.include?("youtu.be")
      uri.path[1..]
    end
  rescue
    nil
  end
end