# Building dev-env

開発環境を構築する一例を示します。
今更な内容ですので、Elmとの連携部分以外は軽く何をやっているか程度の説明しかしません。

## Install

Homebrewを使ってインストールします。
他の方法がよい方は、ご自身でお願いします。  

最初にErlang、Elixir、Nodeをインストールします。

```cmd
$ brew install erlang
$ brew install elixir
$ brew install node

$ erl +V
$ elixir -v
$ node -v

$ mix local.hex
$ mix local.rebar
$ mix local.phx
$ mix local.phoenix

$ npm install -g elm
$ elm -v
```

次はPostgreSQLのインストールします。
また、DBユーザの作成や権限付与も行ってしまいます。
本書ではPhoenixの設定を変更しないで進めるためにDB用のユーザをpostgresで作成しています。

```cmd
$ brew install postgresql

$ initdb /usr/local/var/postgres -E utf8 --no-locale

$ pg_ctl -D /usr/local/var/postgres start
(停止: pg_ctl -D /usr/local/var/postgres stop)

$ psql -l
データベースのリストが表示される

$ export PGDATA=/usr/local/var/postgres

$ createuser -s -d -P postgres
Enter password for new role: (パスワード入力)
Enter it again: (パスワード入力)
(権限: -s=スーパユーザ、-d=データベース作成、パスワード: -P)

$ psql -U postgres
(-U=ユーザ指定オプション)

postgres=# \du (バックスラッシュdu)
ユーザと権限一覧が表示される。
ユーザ: postgres、権限にスーパユーザとデータベース作成がついていれば問題無し
```

## Create new phoenix application

新しいPhoenixのアプリケーションを作成しましょう。

```cmd
$ mix phx.new toy_app

Fetch and install dependencies? [Yn] y

$ cd toy_app

$ mix ecto.create

$ mix phx.server

-> Let's accsess: http://localhost:4000
```

## Git! Git! Managed by git

アプリケーションの資産をGitで管理しましょう。
Githubで管理したい方はリポジトリをご用意ください。

```cmd
$ git init

$ git add -A

$ git status

$ git commit -m "Create phoenix application"

$ git remote add origin https://github.com/[your github account]/toy_app.git

$ git push -u origin master
```

## With Elm

この章で取り扱いたい本題です。PhoenixとElmを連携させます。
Gitを使っているので、せっかくですしブランチを切りましょうか。

```cmd
$ git checkout -b chapter_1
$ git branch
```

Elmについてはnpmでインストールしました。
あれだけでも動かすだけプログラムや設定を作ることもできるのですが、
可能ならPhoenixでサーバを起動するときにビルドやら配置やらを一緒にやってしまいたいです。
また、動作させている中でElmの内容に変更を加えたら、PhoenixのLiveReloaderで再読み込みをしてほしいところです。
開発中にいちいちサーバを落として、Elmをビルドして、また起動するなど面倒臭いので・・・  

そういった設定を行っておけば、面倒臭いのは最初だけになります。
可能な限り作業を自動化して楽をしましょう。それが良いプログラマになる条件の一つだと偉い人が言ってました。
そんなわけで、Phoenixで使っているbrunchの設定でElmを扱えるようにするためにelm-brunchをインストールします。
これがあれば、前述した内容を叶える設定が作れます。

```cmd
$ cd assets
$ npm install --save-dev elm-brunch
```

package.jsonの開発用依存関係に追加されていることを確認します。

```json
[assets/package.json]

{
  ...

  "devDependencies": {
    "babel-brunch": "6.1.1",
    "brunch": "2.10.9",
    "clean-css-brunch": "2.10.0",
    "elm-brunch": "^0.10.0",
    "uglify-js-brunch": "2.10.0"
  }
}
```

お次はelmのパッケージ管理を行うファイル・ディレクトリの作成とソースを管理するディレクトリの作成を行います。
PhoenixとElmを連携させるとき、Elmを配置する場所は二つの候補があります。
Phoenixのアプリケーションの内部に配置し一緒に管理するか、外部に配置し別の管理にするかです。
本書では、Phoenixアプリケーションの内部で管理するように構築していきます。
理由は簡単で、Phoenixの設定にアプリケーション外部を参照する設定をしたくないため。
どうしても必要と判断される場合以外、参照範囲は可能な限り狭めたい。  

それではElmのパッケージ管理を行うファイル・ディレクトリを作成しましょう。
作成する場所はassetsの直下です。
作成するにあたって難しいことは何もありません。コマンド一発で終わります。

```cmd
$ cd assets
$ elm make
Some new packages are needed. Here is the upgrade plan.

  Install:
    elm-lang/core 5.1.1
    elm-lang/html 2.0.0
    elm-lang/virtual-dom 2.0.4

Do you approve of this plan? [Y/n] y
Starting downloads...

  ● elm-lang/html 2.0.0
  ● elm-lang/virtual-dom 2.0.4

  ● elm-lang/core 5.1.1
Packages configured successfully!
Success! Compiled 37 modules.
```

デフォルトでは、Elmのパッケージ管理のファイル・ディレクトリを作成した場所がソースディレクトリとなります。
しかし、assets直下にElmのソース作成していったら、色々と管理しづらくなりますね。
Elmのソースディレクトリの場所を変更します。

```cmd
$ mkdir assets/elm
```

```json
[assets/elm-package.json]

{
    "version": "1.0.0",
    "summary": "helpful summary of your project, less than 80 characters",
    "repository": "https://github.com/user/project.git",
    "license": "BSD3",
    "source-directories": [
        "elm"
    ],
    "exposed-modules": [],
    "dependencies": {
        "elm-lang/core": "5.1.1 <= v < 6.0.0",
        "elm-lang/html": "2.0.0 <= v < 3.0.0"
    },
    "elm-version": "0.18.0 <= v < 0.19.0"
}
```

以降、下記のように呼称します。
文中に出現した場合は適宜読み替えてください。

- ElmHome = `elm make`を実行したディレクトリ
- ElmSrc = `assets/elm`ディレクトリ

続けて、Phoenixのbrunch-configへ設定の追加を行います。
追加する設定は二つです。

(1) 監視対象の追加
(2) elm-brunchの設定を追加

上記の二つです。

(1)は、ElmSrcに変更があった場合にPhoenixのLiveReloaderの対象とするために設定します。
(2)は、自動ビルドとビルドファイルの配置のために行います。

```javascript
[assets/brunch-config.js]

exports.config = {
  ...

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: ["static", "css", "js", "vendor", "elm"],
    // Where to compile files to
    public: "../priv/static"
  },

  // Configure your plugins
  plugins: {
    elmBrunch: {
      mainModules: ["elm/Web.elm"],
      outputFolder: "js",
      outputFile: "elm.js"
    },
    ...
  },

  ...
};
```

設定名から大体の想像はできると思いますが、elm-brunchの設定について簡単に説明したいと思います。

- mainModules = Elmのメインモジュールとして扱うソースを記述します。(複数設定可能)
- outputFolder = Elmのソースビルド時の出力先を指定します。(ElmHomeの相対パスを指定)
- outputFile = Elmのソースビルド時の出力ファイル名を指定します。([outputFolder]で指定したディレクトリに出力)

mainModulesの設定を行いましたが、肝心のメインモジュールを作成していませんね。作成しましょう。
メインモジュールの名称は上記の設定で指定した名称と同じにしてください。

```elm
[assets/vendor/elm/src/Web.elm]

module Web exposing (main)

-- Elm module import
import Html exposing (div, h2, text)

-- main
main =
  div [] [ h2 [] [ text "Hello, elm!" ] ]

```

Elmのメインモジュールをビルドしてビルドエラーが出ないことを確認します。
ここでは手動でビルドします。やり方を知っておいて損はありません。


```cmd
$ elm make src/Web.elm 
Success! Compiled 1 modules.                                        
Successfully generated index.html
```

エラーなくビルドできたようですね。
index.htmlと言うものが出力されていると思います。
Elm単体で動かすときに使うので、消しても消さなくてもよいです。
誤ってgitへ追加しないように、.gitignoreに記載しておくことをお勧めします。  

今後、(何も起こらない限り)手動でやる必要はありませんが、
brunchのビルドを行い、elm.jsが正常に出力されることを確認しておきましょう。
大体はbrunchが上手いことやってくれる。(やってくれない時もある・・・)

```cmd
$ cd assets
$ brunch build
$ ls js
```

assets/js/elm.jsができていれば問題ありません。
続けて、app.jsにElmのコードを埋めこむための定数を作成します。

```javacrprit
[assets/js/app.js]

import "phoenix_html"

// import elm.js
import Elm from "./elm.js"

// Elm embed
const elmDiv = document.getElementById('elm-main')
    , elmApp = Elm.Web.embed(elmDiv)

```

確認を節目節目で行なっていて疲れてきましたね。
もう少しで画面から確認できますので、もう少しだけお付き合いください。  

現在、Phoenixから描画できるページで先ほどのJavaScriptを呼び出します。

```html
[lib/toy_app_web/templates/page/index.html.eex]

<div class="jumbotron">
  <h2><%= gettext "Welcome to %{name}!", name: "Phoenix" %></h2>
  <p class="lead">A productive web framework that<br />does not compromise speed and maintainability.</p>
</div>

<div id="elm-main"></div>

...
```

ようやく画面からElmを確認できます。
Phoenixのサーバを起動して「Hello, Elm」が表示されているか確認してみましょう。

```cmd
$ cd path/to/app
$ mix phx.server
elmがコンパイルされた文言が出る

-> Let's accsess: http://localhost:4000
```

## Commit

本当は細かくaddとcommitをした方がいいのでしょうけど、ここでは最後だけです。
次章からは細かくcommitもしていきます。

```cmd
$ git status

$ git add -A

$ git status

$ git commit -m "Finish create phoenix and elm environments"

$ git push -u origin chapter_1
```

私は面倒臭がりで忘れやすいので、自分だけなら大体最初と最後しかコミットしないのですが、
本当は、ちゃんとやった方がいいのでしょうね・・・(面倒臭い)

## Extra

次の章に進む前の選択肢です。参考にしてください。

```txt
+----------------------------------------------------------+
|
| この本はクソだよ！         -> Sorry...close this book...
| もう少しだけ続けてやるよ   -> Please next chapter
| こんな本が欲しかったんだ！ -> Thanks! Let's next chapter
|
+----------------------------------------------------------+
```


