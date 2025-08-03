require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) { create(:user) }
  let!(:other) { create(:user) }

  context 'ログイン中の場合' do
    before do
      login_as(user, scope: :user)
      user.follow!(other)
    end

    describe "GET /users/:id (show)" do
      it "200 ステータス と 他ユーザーのプロフィール画面が返ってくる" do
        get user_path(other)
        expect(response).to have_http_status(200)
        expect(response.body).to include(other.account)
      end
    end

    describe "GET /user (me)" do
      it "200 ステータス と 自身のプロフィール画面が返ってくる" do
        get my_profile_path
        expect(response).to have_http_status(200)
        expect(response.body).to include(user.account)
      end
    end

    describe "PATCH /user (update)" do
      it "成功時、200 ステータス と アバター画像のURL が返ってくる" do
        new_avatar = fixture_file_upload(Rails.root.join('spec/fixtures/files/test-image.png'), 'image/png')

        patch update_my_profile_path,
          params: { user: { avatar: new_avatar } },
          headers: { 'ACCEPT' => 'application/json' }

        expect(response).to have_http_status(200)
        body = JSON.parse(response.body)
        expect(body['avatar_url']).to be_present
      end

      it "不成功時、422 ステータス が返ってくる" do
        new_avatar = fixture_file_upload(Rails.root.join('spec/fixtures/files/large-image.png'), 'image/png')

        patch update_my_profile_path,
          params: { user: { avatar: new_avatar } },
          headers: { 'ACCEPT' => 'application/json' }

        expect(response).to have_http_status(422)
      end
    end

    describe "GET /users/:id/followings (follow_list)" do
      it "フォロー中のユーザーリストが表示される" do
        get followings_user_path(user)
        expect(response).to have_http_status(200)
        expect(response.body).to include('Followings')
        expect(response.body).to include(other.account)
      end
    end

    describe "GET /users/:id/followers (follow_list)" do
      it "フォロワーリストが表示される" do
        get followers_user_path(other)
        expect(response).to have_http_status(200)
        expect(response.body).to include('Followers')
        expect(response.body).to include(user.account)
      end
    end
  end

  context '未ログイン時' do
    before do
      logout(:user)
    end

    describe "GET /users/:id (show)" do
      it "ログイン画面にリダイレクト" do
        get user_path(other)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET /user (me)" do
      it "ログイン画面にリダイレクト" do
        get my_profile_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "PATCH /user (update)" do
      it "401 Unauthorized が返る" do
        new_avatar = fixture_file_upload(Rails.root.join('spec/fixtures/files/test-image.png'), 'image/png')

        patch update_my_profile_path,
          params: { user: { avatar: new_avatar } },
          headers: { 'ACCEPT' => 'application/json' }

        expect(response).to have_http_status(401)
      end

    end

    describe "GET /users/:id/followings (follow_list)" do
      it "ログイン画面にリダイレクト" do
        get followings_user_path(user)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET /users/:id/followers (follow_list)" do
      it "ログイン画面にリダイレクト" do
        get followers_user_path(user)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
