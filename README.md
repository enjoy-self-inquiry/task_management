*Userモデル*
| カラム名  | データ型 |
| :-------: | :------: |
| id        | integer  |
| user_name | string   |
| email     | string   |

*Taskモデル*
| カラム名 | データ型 |
| :------: | :------: |
| user_id  | integer  |
| title    | string   |
| content  | text     |
| limit    | time     |
| priority | integer  |

*Labelモデル*
| カラム名   | データ型 |
| :--------: | :------: |
| label_name | string   |

*デプロイの手順*
1 herokuにログインする。

2 アセットプリコンパイルを実行。
  ※アセットプリコンパイルとはアセット類（app/assets/以下のファイルの総称）を本番環境で実行できる形式に変換すること。
  $ rails assets:precompile RAILS_ENV=production

3 コミットする。
  $ git add -A
  $ git commit -m ""

4 herokuに新しいアプリを作成する。
　※無料登録かつクレカ未登録の場合、1つのアカウントにつき5つのアプリしか作成できないため注意。
  $ heroku create

5 heroku stackを変更する。
  ※最新バージョンのheroku-20だと、Ruby2.6.5環境で使用できない場合があるため。
  $ heroku stack:set heroku-18
  $ heroku stack・・・現在使用しているstackの確認

6 heroku buildpackを追加する。
  $ heroku buildpacks:set heroku/ruby
  $ heroku buildpacks:add --index 1 heroku/nodejs

7 herokuにデプロイする。
  $ git push heroku master

8 もし7でエラーが出た場合、bundlerのバージョン変更が必要
  (1)Gemfile.lockの削除
    $ rm Gemfile.lock
  (2)バージョン2.1.4のbundlerをインストール
    $ gem install bundler -v 2.1.4
  (3)バージョン2.1.4のbundlerをインストールできているか確認
    $ bundle exec bundle -v
    Bundler version 2.1.4
  (4)上記のように、2.1.4が表示されれば問題ない。

  (5)バージョン2.1.4のbundlerを用いて、再度gemをインストールする
    $ bundler _2.1.4_ install
  (6)再度コミットしたのち、Herokuにpushする
    $ git add -A
    $ git commit -m "bundlerのバージョンを2.1.4に変更"
    $ git push heroku master

9 データベースの移行
  $ heroku run rails db:migrate

10 アプリにアクセスする
  $ heroku config・・・アプリ名を確認する方法
  https://アプリ名.herokuapp.com/にアクセス
