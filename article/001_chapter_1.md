# Building dev-env

何はともあれ、開発環境を作っていきましょう。

## Install Language & DB

まずは各言語をHomebrewを使って入れていきます。め、面倒臭いわけじゃないんだからね！

```cmd
$ brew install erlang
$ brew install elixir
$ brew install node
$ npm install -g elm

$ erl +V
$ elixir -v
$ node -v
$ elm -v
```

次はPostgreSQLのインストールです。め、面倒臭い！

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

[Supplement]
本書ではPhoenixの設定を変更しないで進めるためにDB用のユーザをpostgresで作成しています。
```

## Create new phoenix application

新しいPhoenixのプロジェクトを作成しましょう。

```cmd
$ mix phx.new phoenix_tutorial_with_elm

Fetch and install dependencies? [Yn] y

$ cd phoenix_tutorial_with_elm

$ mix ecto.create

$ mix phx.server
```

## Git! Git! Managed by git

Gitで管理しましょう。
基本、ぼっち開発しかやらないのでソースや環境の管理は雑にやってますが。

```cmd
$ git init

$ git add -A

$ git status

$ git commit -m "[Add] Create application"

$ git remote add origin https://github.com/[your github account]/phoenix_tutorial_with_elm.git

$ git push -u origin master

[Supplement]
Githubのリポジトリはご自身で構築をお願いいたします。
```

## Collaboration Elm

ElmをPhoenixから呼び出せるように設定をしていきましょう。
まずはbrunchから扱うためにelm-brunchをインストールします。

```cmd
$ cd assets
$ npm install --save-dev elm-brunch
```

一応、開発用の依存関係に入れたので、package.jsonに追加されていることを確認します。

```json
[assets/package.json]

{
  "repository": {},
  "license": "MIT",
  "scripts": {
    "deploy": "brunch build --production",
    "watch": "brunch watch --stdin"
  },
  "dependencies": {
    "phoenix": "file:../deps/phoenix",
    "phoenix_html": "file:../deps/phoenix_html"
  },
  "devDependencies": {
    "babel-brunch": "6.1.1",
    "brunch": "2.10.9",
    "clean-css-brunch": "2.10.0",
    "elm-brunch": "^0.10.0",
    "uglify-js-brunch": "2.10.0"
  }
}
```

問題なしですね。
お次はelmのソースを管理するディレクトリを作成します。
Phoenixと連動させるときのElmの管理方法は二つあります。
Phoenixのアプリケーションの内部で管理するか外部で管理するかのどちらかになります。
結局は、ElmのソースをビルドしてまとめたjsをPhoenixに持ってくるので、
一人でやるなら別段代わりはありません。意識することがあるとすれば複数人で編集しているときでしょう。
それもGitが大概の場合うまいことやってくれるでしょうが。
本書では、Phoenixアプリケーションの内部で管理するように構築していきます。

それでは、Elmのディレクトリを作りましょう。

```cmd
$ mkdir assets/vendor/elm
$ cd assets/lib/elm
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

$ mkdir src
$ mkdir output
$ ls
elm-package.json	elm-stuff		src
```

`source-directories`を先ほどのソースディレクトリに変更します。

```json
{
    "version": "1.0.0",
    "summary": "helpful summary of your project, less than 80 characters",
    "repository": "https://github.com/user/project.git",
    "license": "BSD3",
    "source-directories": [
        "src"
    ],
    "exposed-modules": [],
    "dependencies": {
        "elm-lang/core": "5.1.1 <= v < 6.0.0",
        "elm-lang/html": "2.0.0 <= v < 3.0.0"
    },
    "elm-version": "0.18.0 <= v < 0.19.0"
}
```

続けて、brunchの設定を行なっていきます。

```javascript
[assets/brunch-config.js]

exports.config = {
  ...

  // Configure your plugins
  plugins: {
    elmBrunch: {
      // brunch-config.js root relative path
      elmFolder: "./vendor/elm",
      // elm directory relative path
      mainModules: ["src/Web.elm"],
      // elm directory relative path
      outputFolder: "./output"
    },
    ...
  },

  ...
};
```

Elmのメインモジュールを作成していきましょう。
メインモジュールの名称は上記の設定で指定したものにしてください。
異なる名前で作成したい場合、上記の名称を変更することを忘れないように。

```elm
[assets/vendor/elm/src/Web.elm]

module Web exposing (main)

import Html    exposing (Html, program, div, text)
import Model   exposing (Model, new)
import Message exposing (Message)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

init : ( Model, Cmd Message )
init =
  ( Model.new, Cmd.none )

update : Message -> Model -> ( Model, Cmd Message )
update message model =
  ( model, Cmd.none )

view : Model -> Html Message
view model =
  div [] [ text "Hello, elm!" ]

subscriptions : Model -> Sub Message
subscriptions model =
  Sub.none

```

ModelとMessageのモジュールは自分で作らないといけないので作成します。

```elm
[assets/vendor/elm/Model.elm]

module Model exposing (Model, new)

type alias Model =
  { isDebug : Bool
  , message : Maybe String
  }

new : Model
new =
  Model
    False   -- isDebug
    Nothing -- message

```

```elm
[assets/vendor/elm/Message.elm]

module Message exposing (Message, Message(..))

type Message = Nothing

```

それではElmのビルドをしてみましょう。

```cmd
$ elm make src/Web.elm 
Success! Compiled 3 modules.                                        
Successfully generated index.html
```

```javacrprit
[assets/js/app.js]

import "phoenix_html"

// Elm embed
const elmDiv = document.getElementById('elm-main')
    , elmApp = Elm.Web.embed(elmDiv)
```

```html
[lib/phoenix_tutorial_with_elm_web/templates/page/index.html.eex]

<div class="jumbotron">
  <h2><%= gettext "Welcome to %{name}!", name: "Phoenix" %></h2>
  <p class="lead">A productive web framework that<br />does not compromise speed and maintainability.</p>
</div>

<div id="elm-main"></div>

...
```

## Extract

構築だけで疲れましたか？私はこの部分を書いているときに疲れていました(笑)

