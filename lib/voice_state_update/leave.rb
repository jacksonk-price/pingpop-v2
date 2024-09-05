require '../config/config_loader'
require '../lib/pushover'
require '../lib/users'

module VoiceStateUpdate
  class Leave
    def initialize(event)
      @event = event
    end

    def perform
      Pushover.new(user_keys, message).perform
    end

    private

    def user_keys
      USERS.reject { |key, _value| key == @event.user.id.to_s }.values
    end

    def message
      emoji = "\u{1F44B}"
      connected_emoji = "\u{1F7E2}"
      channel = @event.old_channel.name
      user_count = "There is no one else in this channel.\n"

      text_message = "#{@event.user.username} #{emoji} left the voice channel #{channel}.\n\n#{user_count}"
    end
  end
end