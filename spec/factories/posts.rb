FactoryBot.define do
  factory :post do
    caption { Faker::Lorem.sentence }
    association :user

    # 画像ひとつ
    trait :with_image do
      after(:build) do |post|
        file_path = Rails.root.join('spec/fixtures/files/test-image.png')
        post.images.attach(
          io: File.open(file_path),
          filename: 'test-image.png',
          content_type: 'image/png'
        )
      end
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
