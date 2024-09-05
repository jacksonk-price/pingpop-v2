require '../config/config_loader'
require 'net/http'
require 'uri'
require 'json'

class Pushover
  def initialize(user_keys, message)
    @url = URI.parse("https://api.pushover.net/1/messages.json")
    @token = ConfigLoader.config['pushover_token']
    @user_keys = user_keys
    @message = message
  end

  def perform
    @user_keys.each do |uk|
      push_message(uk)
    end
  end

  private

  def push_message(user_key)
    puts '==============================='
    puts 'Pushing notification...'
    puts '==============================='
    http = Net::HTTP.new(@url.host, @url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(@url)
    request.content_type = 'application/json'
    puts build_payload(user_key)
    request.body = build_payload(user_key).to_json

    response = http.request(request)

    puts response.body
  end

  def build_payload(user_key)
    {
      "token" => @token,
      "user" => user_key,
      "message" => @message
    }
  end
end
