require 'slack-ruby-client'
require 'marcel'

class Slacker
  attr_reader :channel

  def initialize(channel)
    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end

    @client = Slack::Web::Client.new
    @channel = channel
    # puts @client.auth_test
  end

  def post(message)
    @client.chat_postMessage(channel: channel, text: message)
  end

  def upload(path, message="")
    @client.files_upload(
      channels: channel,
      file: Faraday::UploadIO.new(path, Marcel::MimeType.for(File.open(path))),
      initial_comment: message,
      # title: 'My Avatar',
      # filename: 'avatar.jpg',
      # as_user: true
    )
  end
end
