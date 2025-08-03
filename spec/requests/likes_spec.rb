require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let!(:user) { create(:user) }
  let!(:other) { create(:user) }
  let!(:pick) { create(:post, user: other) }

  context 'ログイン中' do
    before do
      login_as(user, scope: :user)
    end

    describe "GET /posts/:post_id/like (show)" do
      it "いいねしている状態なら hasLiked が true を返す" do
        create(:like, user: user, post: pick)

        get post_like_path(pick)

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['hasLiked']).to eq(true)
      end

      it "いいねしていない状態なら hasLiked が false を返す" do
        get post_like_path(pick)

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['hasLiked']).to eq(false)
      end
    end

    describe "POST /posts/:post_id/like (create)" do
      it "いいねして、200 ステータスを返す" do
        expect {
          post post_like_path(pick)
        }.to change { pick.reload.likes.count }.by(1)

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('ok')
      end
    end

    describe "DELETE /posts/:post_id/like (destroy)" do
      it "フォロー解除し、200 ステータスを返す" do
        create(:like, user: user, post: pick)
        expect {
          delete post_like_path(pick)
        }.to change { pick.reload.likes.count }.by(-1)

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('ok')
      end
    end
  end
end
