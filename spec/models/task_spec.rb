require 'rails_helper'
RSpec.describe Task, type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空の場合' do
      it 'バリデーションにひっかる' do
        task = Task.new(title: '', content: 'タイトル失敗テスト', expire: "2020-12-31")
        expect(task).not_to be_valid
      end
    end

    context 'タスクの詳細が空の場合' do
      it 'バリデーションにひっかかる' do
        task = Task.new(title: '詳細失敗テスト', content: '', expire: "2020-12-31")
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと詳細に内容が記載されている場合' do
      it 'バリデーションが通る' do
        task = FactoryBot.create(:task, title: '成功テスト', content: '成功テスト', expire: "2020-12-31")
        expect(task).to be_valid
      end
    end
  end

  describe '検索機能' do
    before do
      user = FactoryBot.create(:user, name: 'model_test', email: 'model_test@example.com')
      @task1 = FactoryBot.create(:task, user:user)
      @task2 = FactoryBot.create(:second_task, user:user)
      @task3 = FactoryBot.create(:third_task, user:user)
    end

    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索キーワードを含むタスクが絞り込まれる" do
        expect(Task.search_title('task1')).to include(@task1)
        expect(Task.search_title('task1')).not_to include(@task2)
        expect(Task.search_title('task1')).not_to include(@task3)
        expect(Task.search_title('task1').count).to eq 1
      end
    end
    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        expect(Task.search_progress('着手中')).to include(@task1)
        expect(Task.search_progress('着手中')).to include(@task2)
        expect(Task.search_progress('着手中')).to include(@task3)
        expect(Task.search_progress('着手中').count).to eq 3
      end
    end
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        expect(Task.search_title('task1').search_progress('着手中')).to include(@task1)
        expect(Task.search_title('task1').search_progress('着手中')).not_to include(@task2)
        expect(Task.search_title('task1').search_progress('着手中')).not_to include(@task3)
        expect(Task.search_title('task1').search_progress('着手中').count).to eq 1
      end
    end
  end
end
