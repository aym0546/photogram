require 'rails_helper'

RSpec.describe "Comments", type: :system do
  let!(:user) { create(:user, account: 'test-user') }
  let!(:pick) { create(:post, user: user, caption: 'Nice day!!') }
  let!(:comment) { create(:comment, post: pick, user: user, body: 'This is a test-comment!!') }

  before do
    driven_by(:selenium_chrome_headless)
    login_as(user, scope: :user)
  end

  describe 'GET	/posts/:post_id/comments (index)' do
    before { visit post_comments_path(pick) }

    it '既存のコメントが表示されている' do
      expect(page).to have_selector('.post-comment', text: comment.body)
      expect(page).to have_link(user.account, href: user_path(user))
    end

    it 'コメントを投稿するとページに表示される' do
      fill_in 'comment_body', with: '新しいコメント'
      find('.comment-btn').click

      expect(page).to have_selector('.post-comment', text: '新しいコメント', wait: 5)
    end
  end
end
