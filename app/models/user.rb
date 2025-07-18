class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  validates :account, presence: true,
                      length: { maximum: 25 },
                      uniqueness: true

  def avatar_img
    if self.avatar&.attached?
      self.avatar
    else
      'default.svg'
    end
  end

end
