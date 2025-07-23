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

  has_many :likes, dependent: :destroy

  belongs_to :user

  validates :caption, length: { maximum: 400 }

  validate :images_content_type
  validate :images_size
  validate :images_count

  def url
    Rails.application.routes.url_helpers.post_url(self, host: "http://localhost:3000")
  end

  def images_content_type
    return unless images.attached?

    unless images.all? { |image| image.content_type.in?(%w[image/jpeg image/png image/gif]) }
      errors.add(:images, '：JPEG、PNG、GIFのみアップロード可能です')
    end
  end

  def images_size
    return unless images.attached?

    if images.any? { |image| image.blob.byte_size > 5.megabytes }
      errors.add(:images, '：5MB 以下のファイルのみアップロード可能です')
    end
  end

  def images_count
    return unless images.attached?

    if images.size > 8
      errors.add(:images, '：8 枚までアップロード可能です')
    end
  end

end
