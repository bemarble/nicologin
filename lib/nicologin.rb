require 'net/http'
require 'uri'
require 'nokogiri'

mail =""
pass = "";
uri = URI.parse("https://secure.nicovideo.jp/secure/login?site=nicolive_antenna")

req = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/x-www-form-urlencoded'})
req.set_form_data({'mail'=>mail, 'password'=>pass}, '&')

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
res = http.start {|http| http.request(req) }

xml_doc  = Nokogiri::XML(res.body)

p xml_doc.css("nicovideo_user_response ticket").first.text.to_s

ticket = xml_doc.css("nicovideo_user_response ticket").first.text

#user status
uri = URI.parse("http://live.nicovideo.jp/api/getalertstatus")

req = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/x-www-form-urlencoded'})
req.set_form_data({'ticket'=>ticket}, '&')

http = Net::HTTP.new(uri.host, uri.port)
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
res = http.start {|http| http.request(req) }

puts res.body

xml_doc = Nokogiri::XML(res.body)
