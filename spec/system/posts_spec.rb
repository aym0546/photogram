require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let!(:user) { create(:user, account: 'test') }
  let!(:pick) { create(:post, user: user, caption: 'caption!!') }

  before do
    driven_by(:selenium_chrome_headless)
    login_as(user, scope: :user)
  end

  describe 'GET / (index)' do
    before { visit root_path }

    it '記事一覧が表示される'do
      expect(page).to have_selector('.post')
      expect(page).to have_selector('img')
      expect(page).to have_content('test')
      expect(page).to have_selector('.post-like')
      expect(page).to have_content('caption!!')

      expect(page).to have_css('img.inactive-heart')
      expect(page).to have_css('img.active-heart.offscreen', visible: false)
    end

    it 'いいねボタンを押すとハートが切り替わる' do
      within "[data-controller='like'][data-like-post-id-value='#{pick.id}']" do
        # 初期状態は未いいね
        expect(page).to have_css('img.inactive-heart')
        expect(page).to have_css('img.active-heart.offscreen', visible: false)

        find('img.inactive-heart').click

        # 状態が切り替わることを確認
        expect(page).to have_css('img.active-heart', wait: 5)
        expect(page).to have_css('img.inactive-heart.offscreen', visible: false, wait: 5)
      end
    end
  end

  describe 'GET /posts/:id (show)' do
    it '記事が表示される'do
      visit post_path(pick)

      expect(page).to have_selector('.post')
      expect(page).to have_selector('img')
      expect(page).to have_content('test')
      expect(page).to have_selector('.post-like')
      expect(page).to have_content('caption!!')

      expect(page).to have_css('img.inactive-heart')
      expect(page).to have_css('img.active-heart.offscreen', visible: false)
    end
  end

  describe 'GET /posts/new (new)' do
    before { visit new_post_path }

    it '新規投稿画面が表示される'do
      expect(page).to have_field('post_caption', placeholder: "What's on your mind ?")
      expect(page).to have_content('+ Album')
      expect(page).to have_button('Post')
      expect(page).to have_content('test') # user.account
    end

    it '画像を選択するとプレビューが表示される image_preview' do
      attach_file('image_upload', Rails.root.join('spec/fixtures/files/test-image.png'), make_visible: true)

      expect(page).to have_selector('#preview img', wait: 5)
    end
  end

end
