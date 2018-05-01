require 'omniauth/strategies/github'
require 'octokit'
require 'uri'

module Api
  def self.get(uri, auth=nil)
    uri = URI.parse(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request['authorization'] = "token #{auth}" if auth
    response = http.request(request)
    JSON.parse(response.body)
  end
end
