class NicoLogin
	attr_reader :user_id, :user_name, :user_hash, :is_premium, :communities
	def start email, password

		require 'net/http'
		require 'uri'
		require 'nokogiri'

		uri = URI.parse("https://secure.nicovideo.jp/secure/login?site=nicolive_antenna")

		req = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/x-www-form-urlencoded'})
		req.set_form_data({'mail'=> email, 'password'=>password}, '&')

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		res = http.start {|http| http.request(req) }

		xml_doc  = Nokogiri::XML(res.body)
		#p res.body
		#p xml_doc.css("nicovideo_user_response ticket").first.text.to_s
		#p xml_doc.css("nicovideo_user_response").first["status"];
		unless xml_doc.css("nicovideo_user_response").first["status"] == "ok"
			 raise xml_doc.css("nicovideo_user_response description").text
		end
		
		ticket = xml_doc.css("nicovideo_user_response ticket").first.text

		#user status
		uri = URI.parse("http://live.nicovideo.jp/api/getalertstatus")

		req = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/x-www-form-urlencoded'})
		req.set_form_data({'ticket'=>ticket}, '&')

		http = Net::HTTP.new(uri.host, uri.port)
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		res = http.start {|http| http.request(req) }

		xml_doc = Nokogiri::XML(res.body)
		@user_id   = xml_doc.css("getalertstatus user_id").text
		@user_name   = xml_doc.css("getalertstatus user_name").text
		@user_hash = xml_doc.css("getalertstatus user_hash").text
		@is_premium = xml_doc.css("getalertstatus is_premium").text
		@communities = []
		xml_doc.css("getalertstatus communities community_id").each { |community_id|
			if (/co[0-9]*$/ =~ community_id.text.to_s)
				@communities << community_id.text.to_s
			end
		}
		@communities

		true
	end


end
