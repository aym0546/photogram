# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  caption    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#

class Post < ApplicationRecord
  has_many_attached :images
  belongs_to :user

  def url
    Rails.application.routes.url_helpers.post_url(self, host: "http://localhost:3000")
  end
end
