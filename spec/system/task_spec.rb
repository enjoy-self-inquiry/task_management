require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    visit new_session_path
    fill_in 'Email', with:'test1@example.com'
    fill_in 'Password', with:'123456'
    click_on 'Log in'
    FactoryBot.create(:task, user: @user)
    FactoryBot.create(:second_task, user: @user)
    FactoryBot.create(:third_task, user: @user)
    visit tasks_path
  end

  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in "task[title]", with: 'test_title'
        fill_in "task[content]", with: 'test_content'
        fill_in "task[expire]", with: '2021-12-31'
        select "未着手", from: 'ステータス'
        click_on '登録する'
        expect(page).to have_content 'test_title'
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        expect(page).to have_content 'task1'
      end
    end

    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        expect(all('.task_row')[0] ).to have_content 'task3'
      end
    end

    context 'タスクが終了期限の降順に並んでいる場合' do
      it '終了期限の最も近いタスクが一番上に表示される' do
        click_on '終了期限でソートする'
        sleep 1
        expect(all('.task_row')[0] ).to have_content 'task3'
      end
    end

    context 'タスクを優先度でソートした場合' do
      it '優先度が最も高いタスクが一番上に表示される' do
        click_on '優先度でソートする'
        task_list = all('.task_row')
        expect(all('.task_row')[0]).to have_content '高'
      end
    end
  end

  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示される' do
         @task4 = FactoryBot.create(:fourth_task, user: @user)
         visit task_path(@task4)
         expect(page).to have_content 'task4'
         expect(page).to have_content 'task4_content'
       end
     end
  end

  describe '検索機能' do
    context 'タイトルであいまい検索をした場合' do
      it "検索キーワードを含むタスクで絞り込まれる" do
        fill_in 'task[title]', with: '1'
        click_on '検索'
        expect(page).to have_content 'task1'
      end
    end

    context 'ステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        select '未着手', from: 'task[progress]'
        click_on '検索'
        expect(page).to have_content '未着手'
      end
    end

    context 'タイトルのあいまい検索とステータス検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        fill_in 'task[title]', with: 'task1'
        select '着手中', from: 'task[progress]'
        click_on '検索'
        expect(page).to have_content 'task1'
        expect(page).to have_content '着手中'
      end
    end
  end
end
