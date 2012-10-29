require_relative 'lib/nicologin'

begin
	login = NicoLogin.new
	r = login.start "YourEmail@hogehoge.com", "YourPassword"
	p login.user_id #ユーザーID
	p login.user_name #ユーザー名
	p login.ispremium #プレミアム
rescue => e
	puts e.message
end

