require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user, :with_image, account: 'test-user') }
  let!(:other) { create(:user, :with_image, account: 'other-user') }

  before do
    driven_by(:selenium_chrome_headless)
  end

  context '本人のプロフィールページを表示したとき' do
    before do
      login_as(user, scope: :user)
      visit user_path(user)
    end

    describe 'GET	/users/:id (show)' do
      it 'ページ内にアバター画像とアップロードフォームが存在する' do
        expect(page).to have_selector('#avatar-form')
        expect(page).to have_selector('input[type="file"]#avatar-input', visible: false)
        expect(page).to have_selector('#avatar-preview')

        expect(page).to have_content(user.account)
        expect(page).to have_selector('img#avatar-preview')
        expect(page).to have_link('Log out')
        expect(page).to have_content('Posts')
        expect(page).to have_content('Followers')
        expect(page).to have_content('Following')
      end

      it '画像を選択するとアバター画像のプレビューが更新される', js: true do
        attach_file('avatar-input', Rails.root.join('spec/fixtures/files/dummy-image.png'), make_visible: true)
        page.execute_script("document.getElementById('avatar-input').dispatchEvent(new Event('change', { bubbles: true }))")

        expect {
          expect(page).to have_selector('#avatar-preview[src*="rails/active_storage"]', wait: 5)
        }.to change { find('#avatar-preview')[:src] }
      end
    end
  end

  context '本人以外のプロフィールページを表示したとき' do
    before do
      login_as(user, scope: :user)
      visit user_path(other)
    end

    describe 'GET	/users/:id (show)' do
      it 'ページ内にアバター画像が存在し、アップロードフォームは存在しない' do
        expect(page).not_to have_selector('#avatar-form')
        expect(page).not_to have_selector('input[type="file"]#avatar-input', visible: false)
        expect(page).not_to have_selector("img#avatar-preview")

        expect(page).not_to have_link('Log out')
        expect(page).to have_content('Follow')
        expect(page).to have_content(other.account)
        expect(page).to have_content('Posts')
        expect(page).to have_content('Followers')
        expect(page).to have_content('Following')
      end
    end
  end

  context 'フォロー状態（user > other）にある時' do
    before do
      user.follow!(other)
    end

    describe 'フォローリスト' do
      it 'フォロー中のユーザーが表示され、リンクされている' do
        login_as(user, scope: :user)
        visit followings_user_path(user)

        expect(page).to have_content('Followings')
        expect(page).to have_selector('.follow_list', count: 1)
        expect(page).to have_selector('img')
        expect(page).to have_content(other.account)
        expect(page).to have_content('Last seen 3 hours ago')
        expect(page).to have_link(href: user_path(other))
      end
    end

    describe 'フォロワーリスト' do
      it 'フォローされているユーザーが表示され、リンクされている' do
        login_as(other, scope: :user)
        visit followers_user_path(other)

        expect(page).to have_content('Followers')
        expect(page).to have_selector('.follow_list', count: 1)
        expect(page).to have_selector('img')
        expect(page).to have_content(user.account)
        expect(page).to have_content('Last seen 3 hours ago')
        expect(page).to have_link(href: user_path(user))
      end
    end
  end
end
