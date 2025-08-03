require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:user) { create(:user) }
  let!(:other) { create(:user) }
  let!(:pick) { create(:post, user: other) }
  let!(:comment1) { create(:comment, user: other, post: pick, body: 'Hello!') }
  let!(:comment2) { create(:comment, user: user, post: pick, body: 'Hi!!') }

  context 'ログイン済みの場合' do
    before { login_as(user, scope: :user) }

    describe "GET /posts/:post_id/comments (index)" do
      it "HTML形式でアクセス時、200 ステータスを返す" do
        get post_comments_path(pick)
        expect(response).to have_http_status(200)
      end

      it "JSON形式でアクセス時、コメント情報とユーザー情報を含むJSONを返す" do
        get post_comments_path(pick), as: :json

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)

        expect(json).to be_an(Array)
        expect(json.first['body']).to eq(comment1.body)
        expect(json.first['user']).to include('id', 'account', 'avatar_url')
        expect(json.second['body']).to eq(comment2.body)
        expect(json.second['user']).to include('id', 'account', 'avatar_url')
      end
    end

    describe "POST /posts/:post_id/comments (create)" do
      it "コメントを作成し、JSONを返す" do
        expect {
          post post_comments_path(pick), params: { comment: { body: 'New Comment' } }, as: :JSON
        }.to change { pick.comments.count }.by(1)

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['body']).to eq('New Comment')
        expect(json['user']).to include('account', 'avatar_url')
      end

      it "バリデーションエラー（スペースのみ）の場合、コメントは保存されず、422を返す" do
        post post_comments_path(pick), params: { comment: { body: '  ' } }, as: :JSON

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to include('コメント内容 を入力してください')
      end
    end
  end
end
