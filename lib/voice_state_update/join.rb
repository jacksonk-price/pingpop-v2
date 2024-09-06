require '../lib/pushover'
require '../lib/users'

module VoiceStateUpdate
  class Join

    def initialize(event)
      @event = event
    end

    def perform
      Pushover.new(user_keys, message).perform
    end

    private

    def users
      @event.channel.users
    end

    def user_ids
      users.map { |user| user.id.to_s }
    end

    def user_keys
      puts user_ids
      # only get keys for users not in the channel at the moment, including user that triggered the event
      USERS.reject { |key, _value| user_ids.include?(key) || key == @event.user.id.to_s }.values
    end

    def message
      emoji = "\u{1F91D}"
      connected_emoji = "\u{1F7E2}"
      channel = @event.channel.name

      text_message = "#{@event.user.username} #{emoji} joined the voice channel #{channel}.\n"
      text_message += users.map { |user| "#{connected_emoji} #{user.username}\n" }.join('')
    end
  end
end