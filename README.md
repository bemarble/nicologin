nicologin
=========

nicnico API login

ニコニコ動画にログインして各種情報を取得するためのRubyライブラリです。
ログイン成功時にユーザー情報の取得ができます。

サンプルコード

```ruby:sample.rb
require_relative 'lib/nicologin'

begin
  login = NicoLogin.new
  r = login.start "YourEmail@hogehoge.com", "YourPassword"
  p login.user_id #ユーザーID
  p login.user_name #ユーザー名
  p login.user_hash #ログインハッシュ
  p login.ispremium #プレミア
  p login.communities #参加中コミュニティ
rescue => e
  puts e.message
end
```

