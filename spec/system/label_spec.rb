require 'rails_helper'
RSpec.describe 'ラベル機能', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @task = FactoryBot.create(:task, user: @user)
    #@second_task = FactoryBot.create(:second_task, user: @user)
    @label = FactoryBot.create(:label)
    @second_label = FactoryBot.create(:second_label)
    @third_label = FactoryBot.create(:third_label)
    #FactoryBot.create(:task_label, task:@task, label:@label)
    #FactoryBot.create(:task_label, task:@task, label:@second_label)
    #FactoryBot.create(:task_label, task:@second_task, label:@third_label)
    visit new_session_path
    fill_in 'Email', with:'test1@example.com'
    fill_in 'Password', with:'123456'
    click_on 'Log in'
    visit tasks_path
  end

  context '複数のラベルを付けてタスクの新規作成した場合' do
    it 'タスクに選択したラベルが表示される' do
      visit new_task_path
      fill_in "task[title]", with: 'label_test'
      fill_in "task[content]", with: 'label_test_content'
      fill_in "task[expire]", with: '2021-12-30'
      select "着手中", from: "ステータス"
      check "0番目のラベル"
      check "1番目のラベル"
      click_on "登録する"
      expect(page).to have_content '0番目のラベル'
      expect(page).to have_content '1番目のラベル'
      expect(page).to have_content 'label_test'
      expect(page).not_to have_content '2番目のラベル'
    end
  end

  context 'タスクのラベルを外して編集した場合' do
    it 'タスクから外したラベルが消えている' do
      visit edit_task_path(@task.id)
      #select "中", from: 'task[priority]'
      #select "着手中", from: "ステータス"
      uncheck "0番目のラベル"
      check "2番目のラベル"
      click_on "更新する"
      visit task_path(@task)
      expect(page).not_to have_content '0番目のラベル'
      expect(page).to have_content '2番目のラベル'
    end
  end

  context 'ラベル検索をした場合' do
    it "検索したラベルが含まれるタスクのみに絞り込まれる" do
      visit new_task_path
      fill_in "task[title]", with: 'label_test1'
      fill_in "task[content]", with: 'label_test_content1'
      fill_in "task[expire]", with: '2021-12-30'
      select "着手中", from: "ステータス"
      check "0番目のラベル"
      check "1番目のラベル"
      click_on "登録する"
      visit new_task_path
      fill_in "task[title]", with: 'label_test2'
      fill_in "task[content]", with: 'label_test_content2'
      fill_in "task[expire]", with: '2021-12-31'
      select "完了", from: "ステータス"
      check "2番目のラベル"
      click_on "登録する"
      visit tasks_path
      select "2番目のラベル", from: "label_id"
      click_on "Search"
      expect(page).not_to have_content 'label_test1'
      expect(page).to have_content 'label_test2'
    end
  end
end
