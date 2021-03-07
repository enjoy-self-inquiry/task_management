require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  before do
    FactoryBot.create(:task, title: 'test1', content: '緊急性　高', expire: '2021-01-01')
    FactoryBot.create(:task, title: 'test2', content: '緊急性　低', expire: '2021-03-03')
    FactoryBot.create(:task, title: 'test3', content: '緊急性　中', expire: '2021-02-02')
    visit tasks_path
  end
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in "タイトル", with: 'test_title'
        fill_in "内容", with: 'test_content'
        fill_in "終了期限", with: '2021-12-31'

        click_on '登録する'
        expect(page).to have_content 'test_title'
      end
    end
  end
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        expect(page).to have_content 'test1'
      end
    end
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        expect(all('.task_row')[0] ).to have_content 'test3'
      end
    end
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        click_on '終了期限でソートする'
        expect(all('.task_row')[0] ).to have_content '緊急性　高'
      end
    end
  end
  describe '詳細表示機能' do
     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示される' do
         @task = FactoryBot.create(:task,title: 'task1',content: 'content1' )
         visit task_path(@task)
         expect(page).to have_content 'task1'
         expect(page).to have_content 'content1'
       end
     end
  end
end
