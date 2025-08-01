require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  let!(:user) { create(:user) }
  let!(:other) { create(:user) }

  context 'ログイン中' do
    before do
      login_as(user, scope: :user)
    end

    describe "POST /relationships (create)" do
      it "ユーザーをフォローし、JSON が返ってくる" do
        expect {
          post relationships_path, params: { followed_id: other.id }, as: :json
       }.to change { user.followings.count }.by(1)

        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json['following']).to eq(true)
        expect(json['followers_count']).to eq(other.followers.count)
        expect(json['next_url']).to eq(relationship_path(user.relationship_with(other)))
      end
    end

    describe "DELETE /relationships (destroy)" do
      let!(:relationship) do
        user.follow!(other)
        user.relationship_with(other)
      end

      it "フォローを解除し、JSON が返ってくる" do
        expect {
          delete relationship_path(relationship), as: :json
        }.to change { user.followings.count }.by(-1)

        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json['following']).to eq(false)
        expect(json['followers_count']).to eq(other.followers.count)
        expect(json['next_url']).to eq(relationships_path(followed_id: other.id))
      end
    end

  end

  context '未ログイン時' do
    before do
      logout(:user)
    end

    describe "POST /relationships (create)" do
      it "401 Unauthorized が返る" do
        post relationships_path, params: { followed_id: other.id }, as: :json

        expect(response).to have_http_status(401)
      end
    end

    describe "DELETE /relationships (destroy)" do
      let!(:relationship) do
        user.follow!(other)
        user.relationship_with(other)
      end

      it "401 Unauthorized が返る" do
        delete relationship_path(relationship), as: :json

        expect(response).to have_http_status(401)
      end
    end

  end

end
