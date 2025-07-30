FactoryBot.define do
  factory :user do
    account { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    password { 'password' }

    trait :with_image do
      after(:build) do |user|
        file_path = Rails.root.join('spec/fixtures/files/test-image.png')
        user.avatar.attach(
          io: File.open(file_path),
          filename: 'test-image.png',
          content_type: 'image/png'
        )
      end
    end

  end

end
