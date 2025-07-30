require 'rails_helper'

RSpec.describe Comment, type: :model do

  describe 'Validation' do

    it 'コメント内容が 400文字以下 の場合は有効' do
      comment = build(:comment, body: Faker::Lorem.characters(number: 400))
      expect(comment).to be_valid
    end

    it 'コメント内容が ない 場合は無効' do
      comment = build(:comment, body: nil)

      comment.valid?
      expect(comment.errors[:body]).to include('を入力してください')
    end

    it 'コメント内容が 空文字 の場合は無効' do
      comment = build(:comment, body: '')

      comment.valid?
      expect(comment.errors[:body]).to include('を入力してください')
    end

    it 'コメント内容が 400文字を超える 場合は無効' do
      comment = build(:comment, body: Faker::Lorem.characters(number: 401))

      comment.valid?
      expect(comment.errors[:body]).to include('は 400文字以内 で入力してください')
    end

  end

end
