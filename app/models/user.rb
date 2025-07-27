class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :following_relationships, foreign_key: 'follower_id', class_name: 'Relationship', dependent: :destroy
  has_many :followings, through: :following_relationships, source: :following
  has_many :follower_relationships, foreign_key: 'following_id', class_name: 'Relationship', dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  validates :account, presence: true,
                      length: { maximum: 25 },
                      uniqueness: true

  validate :avatar_content_type
  validate :avatar_size

  def follow!(user)
    if user.is_a?(User)
      user_id = user.id
    else
      user_id = user
    end

    following_relationships.create!(following_id: user_id)
  end

  def unfollow!(user)
    following_relationships.find_by!(following_id: user.id).destroy!
  end

  def following?(user)
    followings.include?(user)
  end

  def relationship_with(other_user)
    following_relationships.find_by(follower_id: self.id, following_id: other_user.id)&.id
  end

  def avatar_img
    if self.avatar&.attached?
      self.avatar
    else
      'default.svg'
    end
  end

  def avatar_content_type
    if avatar.attached? && !avatar.content_type.in?(%w[image/jpeg image/png image/gif])
      errors.add(:avatar, '：JPEG、PNG、GIFのみアップロード可能です')
    end
  end

  def avatar_size
    if avatar.attached? && avatar.blob&.byte_size > 5.megabytes
      errors.add(:avatar, '：5MB 以下のファイルのみアップロード可能です')
    end
  end

  def has_liked?(post)
    likes.exists?(post_id: post.id)
  end

  def avatar_url
    avatar.attached? ? Rails.application.routes.url_helpers.rails_blob_url(avatar, host: 'http://localhost:3000') : nil
  end

end
