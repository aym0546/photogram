class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :account, presence: true,
                      length: { maximum: 25 },
                      uniqueness: true

  validate :avatar_content_type
  validate :avatar_size

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

end
