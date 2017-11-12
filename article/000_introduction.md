# Phoenix Tutorial with Elm-Lang

## Index

Coming soon...

- Static pages
- Accounts
- Sign up
- Sign-in and Sign-out
- Articles

## Foreword

以前、記事や本を読んでいただいた方にはお久しぶりです。新しく読んでくれた方には始めまして！  

本書は、バックエンドにElixir+Phoenix、フロントエンドにElmを使い、簡単なブログサイトを作成していく内容となっています。
Phoenixの基本的な使い方から始まり、バックエンドAPIの構築、そしてElmを使ったフロントエンドの構築を行なっていきます。
ElixirでWeb開発を行う上で欠かすことのできない内容が(全て無料で)載っています。(ElixirでWeb開発をしないとは思いますが...)
また、GitやGithubを使いそれぞれの章毎に作っていきます。そのため、実際の開発に近い形で学習を進めていくことができるかと思います。  

本書の進め方としてオススメは、Ruby on Rails Tutorialのように一気に進めることですが、
お時間を取るのが難しい方もいると思いますので、気ままにやってもらえればと思います。
一気に駆け抜けるも良し、休憩を挟みつつ少しずつ進めるも良し...やり方はひとそれぞれです。自分のペースにあったやり方で進めてください！  

Elixirで仕事をしている方、趣味でElixirを書いている方、Elixirに興味はあるけどまだ手を出していない方、その他大勢の方...
その方たちにインスピレーションを与えることができたらなら、これほど素晴らしいことはありません。
そして少しでも、Elixirという言語の布教に役立つことができたら幸いです。  

それでは、楽しんでいただけたら幸いです。  

追伸...
ソースコード一式はGithubへアップしています。  
Github: https://github.com/darui00kara/phoenix_tutorial_with_elm  

## Acknowledgments

本書の存在は、Elixir言語とPhoenixフレームワーク、Elm-Langがなければ作る事さえなかったものです。
José Valim氏とChris McCord氏、Evan Czaplicki氏へは敬意を表すると共に感謝を捧げたいと思います。  
また本書のパクリ元・・・もとい参考にさせていただいたRuby on Rails Tutorialの作者様、
日本語訳を行なっている訳者様方にも敬意と感謝を捧げます。
この中のどなたが欠けても、本書を作ることはなかったでしょう。  

そして、私にインスピレーションと知識を与えてくれた@hayabusa333氏にも大いなる感謝をしたいと思います。  
「いつも私のわがままを聞いてくれてありがとう！」  

## Dev-Environment

本書の開発環境は下記のとおりです。  

- OS: MacOS X v10.16.6
- Homebrew: 1.2.5
- Git: 2.13.5 (Apple Git-94)
- Erlang: Eshell V9.0, OTP-Version 20
- Elixir: v1.5.0
  * Phoenix Framework: v1.3.0
- Elm-Lang : v0.18.0
- Node.js: v8.2.1
- PostgreSQL: postgres (PostgreSQL) 9.6.1

