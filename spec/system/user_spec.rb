require 'rails_helper'
RSpec.describe 'ユーザー管理機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @second_user = FactoryBot.create(:second_user)
    @third_user = FactoryBot.create(:third_user)
  end


  describe 'ユーザー登録テスト' do
    context 'ユーザーの新規登録をした場合' do
      it '新規登録したユーザーのマイページが表示される' do
        visit new_user_path
        fill_in "名前", with: "テスト"
        fill_in "メールアドレス", with: "test@dic.com"
        fill_in "パスワード", with: "test1234"
        fill_in "確認用パスワード", with: "test1234"
        click_on "Create my account"
        expect(page.text).to include "テスト"
        expect(page.text).to include "test@dic.com"
      end
    end

    context 'ユーザがログインせずタスク一覧画面に飛ぼうとした時' do
      it 'ログイン画面に遷移する'do
        visit tasks_path
        expect(current_path).to eq new_session_path
        expect(current_path).not_to eq tasks_path
        expect(page).to have_content 'Log in'
      end
    end
  end

  describe 'セッション機能のテスト' do
    before do
      visit new_session_path
      fill_in 'Email', with: "test1@example.com"
      fill_in 'Password', with: "123456"
      click_on "Log in"
    end

    context 'ログインした場合' do
      it 'ログインしたユーザーのマイページが表示される' do
        expect(current_path).to eq user_path(@user.id)
        expect(page).to have_content 'test1'
        expect(page).to have_content 'test1@example.com'
        expect(current_path).not_to eq user_path(@second_user.id)
        expect(page).not_to have_content 'test2'
        expect(page).not_to have_content 'test2@example.com'
      end
    end

    context 'プロフィールをクリックした場合' do
      it '自分のマイページが表示される' do
        visit tasks_path
        click_on 'プロフィール'
        expect(current_path).to eq user_path(@user.id)
        expect(page).to have_content 'test1'
        expect(page).to have_content 'test1@example.com'
        expect(current_path).not_to eq user_path(@second_user.id)
        expect(page).not_to have_content 'test2'
        expect(page).not_to have_content 'test2@example.com'
      end
    end

    context '一般ユーザが他人の詳細画面に飛んだ場合' do
      it 'タスク一覧画面に遷移する' do
        visit user_path(@second_user.id)
        expect(current_path).to eq tasks_path
        expect(page).to have_content '終了期限でソートする'
        expect(current_path).not_to eq user_path(@second_user.id)
      end
    end

    context 'ログアウトした場合' do
      it 'ログイン画面に戻る' do
        click_on 'ログアウト'
        expect(current_path).to eq new_session_path
        expect(current_path).not_to eq user_path(@user.id)
        expect(page).to have_content 'Log in'
      end
    end
  end

  describe '管理画面のテスト' do
    before do
      visit new_session_path
      fill_in 'Email', with:'test1@example.com'
      fill_in 'Password', with:'123456'
      click_on 'Log in'
    end

    context '管理ユーザーが管理画面にアクセスした場合' do
      it 'ユーザー一覧の画面に遷移する' do
        visit admin_users_path
        expect(current_path).to eq admin_users_path
        expect(current_path).not_to eq tasks_path
        expect(page).to have_content 'ユーザー一覧'
      end
    end

    context '一般ユーザーが管理画面にアクセスした場合' do
      it '管理画面にアクセスできない' do
        click_on 'ログアウト'
        visit new_session_path
        fill_in 'Email', with:'test2@example.com'
        fill_in 'Password', with:'123456'
        click_on 'Log in'
        visit admin_users_path
        expect(current_path).not_to eq admin_users_path
        expect(current_path).to eq tasks_path
        expect(page).to have_content '管理者以外はアクセスできません'
      end
    end

    context '管理ユーザーがユーザーの新規登録した場合' do
      it '管理者用のユーザー詳細ページに遷移する' do
        visit new_admin_user_path
        fill_in '名前', with:'test'
        fill_in 'メールアドレス', with:'admin_test@example.com'
        fill_in 'パスワード', with:'123456'
        fill_in '確認用パスワード', with:'123456'
        uncheck 'user[admin]'
        click_on 'Create my account'
        expect(page).to have_content 'test'
        expect(page).to have_content 'admin_test@example.com'
        expect(page).to have_content 'ユーザーを作成しました'
        expect(page).to have_content 'ユーザー一覧'
      end
    end

    context '管理ユーザーの場合' do
      it '一般ユーザー詳細ページにアクセスできる' do
        #test = FactoryBot.create(:user, name: "test", email: "admin_test@example.com")
        visit admin_users_path
        visit admin_user_path(@second_user.id)
        #expect(current_path).to eq admin_user_path(test)
        #expect(current_path).not_to eq user_path(test)
        expect(page).to have_content 'ユーザー情報'
        expect(page).to have_content '権限'
      end
    end

    context '管理ユーザーがを管理者用アカウント編集画面にアクセスした場合' do
      it 'ユーザーの編集ができる' do
        visit edit_admin_user_path(@user)
        fill_in '名前', with:'edit'
        fill_in 'メールアドレス', with:'edit@example.com'
        fill_in 'パスワード', with:'111111'
        fill_in '確認用パスワード', with:'111111'
        check 'user[admin]'
        click_on 'Create my account'
        expect(current_path).to eq admin_users_path
        expect(current_path).not_to eq user_path(@user)
        expect(page).to have_content 'edit'
        expect(page).to have_content 'edit@example.com'
        expect(page).to have_content '有'
        expect(page).to have_content 'ユーザーを編集しました'
      end
    end

    context '管理ユーザーがユーザーの削除ボタンを押した場合' do
      it 'ユーザーの削除ができる' do
        visit admin_users_path
        all('.user_row')[1].click_link '削除'
        page.driver.browser.switch_to.alert.accept
        expect(current_path).to eq admin_users_path
        expect(all('.user_row')[0]).to have_content "#{@user.name}"
        expect(all('.user_row')[0]).to have_content "#{@user.email}"
        expect(all('.user_row')[0]).not_to have_content "#{@second_user.name}"
        expect(all('.user_row')[0]).not_to have_content "#{@second_user.email}"
        expect(page).to have_content "ユーザーを削除しました"
      end
    end
  end
end
