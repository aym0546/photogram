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

FactoryBot.define do
  factory :post do
    caption { Faker::Lorem.sentence }
    association :user

    # 画像ひとつ
    after(:build) do |post|
      file_path = Rails.root.join('spec/fixtures/files/test-image.png')
      post.images.attach(
        io: File.open(file_path),
        filename: 'test-image.png',
        content_type: 'image/png'
      )
    end

    # 画像複数
    trait :with_multiple_images do
      after(:build) do |post|
        3.times do |i|
          file_path = Rails.root.join('spec/fixtures/files/test-image.png')
          post.images.attach(
            io: File.open(file_path),
            filename: "test-image_#{i}.png",
            content_type: 'image/png'
          )
        end
      end
    end
  end
end
