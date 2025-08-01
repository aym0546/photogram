require 'rails_helper'

RSpec.describe "Posts", type: :request do

  let!(:user) { create(:user) }
  let!(:post_by_user) { create(:post, user: user) }

  let!(:other_user) { create(:user) }
  let!(:post_by_other) { create(:post, user: other_user) }

  let(:image_path) { Rails.root.join('spec/fixtures/files/test-image.png') }
  let(:uploaded_image) { Rack::Test::UploadedFile.new(image_path, 'image/png') }

  describe 'GET / (index)' do
    it 'ログイン中ユーザーのフォロー中の投稿と人気投稿が表示' do
      login_as(user, scope: :user)
      user.follow!(other_user)

      get root_path
      expect(response).to have_http_status(200)

      expect(response.body).to include(post_by_other.caption)
    end

    it '未ログインの場合、ログイン画面にリダイレクト' do
      logout(:user)
      get root_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'GET /posts/:id (show)' do
    it '200ステータス と ポストの詳細ページ が返ってくる' do
      get post_path(post_by_user)
      expect(response).to have_http_status(200)
      expect(response.body).to include(post_by_user.caption)
    end
  end

  describe 'GET /posts/new (new)' do
    it '新規投稿画面が表示される' do
      login_as(user, scope: :user)
      get new_post_path
      expect(response).to have_http_status(200)
    end

    it '未ログインの場合、ログイン画面にリダイレクト' do
      logout(:user)
      get new_post_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'POST /posts (create)' do
    before do
      login_as(user, scope: :user)
    end

    context '有効なパラメータの場合' do
      let(:valid_params) do
        {
          post: {
            user_id: user.id,
            caption: 'RSpec によるテスト',
            images: [uploaded_image]
          }
        }
      end

      it 'ポストが作成され、リダイレクトされる' do
        expect {
          post posts_path, params: valid_params
        }.to change(Post, :count).by(1)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('ポストされました')
      end
    end

    context '無効なパラメータの場合' do
      let(:valid_params) do
        {
          post: {
            user_id: user.id,
            caption: 'RSpec によるテスト',
            images: [] # 画像なし
          }
        }
      end

      it 'ポストが作成されず、リダイレクトされる' do
        expect {
          post posts_path, params: valid_params
        }.not_to change(Post, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('ポストされませんでした')
      end
    end

    it '未ログインなら投稿できない' do
      logout(:user)
      post posts_path, params: { post: { caption: 'ログインなし投稿', images: [uploaded_image] } }
      expect(response).to redirect_to(new_user_session_path)
    end

  end
end
