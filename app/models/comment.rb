# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  body       :text
#  user_id    :integer          not null
#  post_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, presence: true, length: { maximum: 400 }

  after_create :check_mention

  private
  def check_mention
    mentions = body.scan(/@(\w+)/).flatten
    mentions.each do |mention|
      mentioned_user = User.find_by(account: mention)
      if mentioned_user
        MentionMailer.notify_mention(mentioned_user, self, user).deliver_later
      end
    end
  end
end
