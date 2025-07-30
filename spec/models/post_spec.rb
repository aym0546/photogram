require 'rails_helper'

RSpec.describe Post, type: :model do

  describe 'Validation' do
    it 'キャプションが 400文字以下 の場合は有効' do
      post = build(:post, caption: Faker::Lorem.characters(number: 400))
      expect(post).to be_valid
    end

    it 'キャプションが ない 場合にも有効' do
      post = build(:post, caption: nil)

      post.valid?
      expect(post).to be_valid
    end

    it 'キャプションが 400文字を超える 場合は無効' do
      post = build(:post, caption: Faker::Lorem.characters(number: 401))

      post.valid?
      expect(post.errors[:caption]).to include('は 400文字以内 で入力してください')
    end

    it '画像の拡張子が PNG の場合は有効' do
      post = build(:post, :with_image)
      expect(post).to be_valid
    end

    it 'JPEG, PNG, GIF 以外の形式は無効' do
      post = build(:post)
      file = fixture_file_upload(Rails.root.join('spec/fixtures/files/sample.bmp'), 'image/bmp')
      post.images.attach(file)

      post.valid?
      expect(post.errors[:images]).to include('：JPEG、PNG、GIFのみアップロード可能です')
    end

    it '5MB を超えるファイルサイズの場合は無効' do
      post = build(:post)

      large_file_path = Rails.root.join('spec/fixtures/files/large-image.png')
      post.images.attach(
        io: File.open(large_file_path),
        filename: 'large-image.png',
        content_type: 'image/png'
      )

      post.valid?
      expect(post.errors[:images]).to include('：5MB 以下のファイルのみアップロード可能です')
    end

    it '8枚以下 の画像枚数の場合は有効' do
      post = build(:post)

      8.times do |i|
        file_path = Rails.root.join('spec/fixtures/files/test-image.png')
        post.images.attach(
          io: File.open(file_path),
          filename: "test-image_#{i}.png",
          content_type: 'image/png'
        )
      end

      expect(post).to be_valid
    end

    it '9枚以上 の画像枚数の場合は無効' do
      post = build(:post)

      9.times do |i|
        file_path = Rails.root.join('spec/fixtures/files/test-image.png')
        post.images.attach(
          io: File.open(file_path),
          filename: "test-image_#{i}.png",
          content_type: 'image/png'
        )
      end

      post.valid?
      expect(post.errors[:images]).to include('：8 枚までアップロード可能です')
    end

  end
end
