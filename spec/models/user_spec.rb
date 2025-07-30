require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validation' do
    it 'アカウントが 25文字以下 の場合は有効' do
      user = build(:user, account: Faker::Lorem.characters(number: 25))
      expect(user).to be_valid
    end

    it 'アカウントが 26文字以上 の場合には無効' do
      user = build(:user, account: Faker::Lorem.characters(number: 26))

      user.valid?
      expect(user.errors[:account]).to include('は 25文字以内 で入力してください')
    end

    it 'アカウントが ない 場合には無効' do
      user = build(:user, account: nil)

      user.valid?
      expect(user.errors[:account]).to include('を入力してください')
    end

    it 'アカウントが 重複する 場合には無効' do
      create(:user, account: 'testaccount')

      user = build(:user, account: 'testaccount')

      user.valid?
      expect(user.errors[:account]).to include('testaccount はすでに存在します')
    end

    it '画像の拡張子が 5MB以下 の PNG の場合は有効' do
      user = build(:user, :with_image)
      expect(user).to be_valid
    end

    it 'JPEG, PNG, GIF 以外の形式は無効' do
      user = build(:user)
      file = fixture_file_upload(Rails.root.join('spec/fixtures/files/sample.bmp'), 'image/bmp')
      user.avatar.attach(file)

      user.valid?
      expect(user.errors[:avatar]).to include('：JPEG、PNG、GIFのみアップロード可能です')
    end

    it '5MB を超えるファイルサイズの場合は無効' do
      user = build(:user)

      large_file_path = Rails.root.join('spec/fixtures/files/large-image.png')
      user.avatar.attach(
        io: File.open(large_file_path),
        filename: 'large-image.png',
        content_type: 'image/png'
      )

      user.valid?
      expect(user.errors[:avatar]).to include('：5MB 以下のファイルのみアップロード可能です')
    end

  end
end
