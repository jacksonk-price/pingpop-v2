require 'json'
require '../config/config_loader'
require '../lib/utils'
require '../lib/pushover'
require '../lib/voice_state_update/join'
require '../lib/voice_state_update/leave'

include Utils

class Bot
  def initialize
    @bot = Discordrb::Commands::CommandBot.new(
      token: ConfigLoader.config['pingpop_token'],
      prefix: '!'
    )
    set_listeners
  end

  def run
    @bot.run
  end

  private

  def set_listeners
    set_ready_listener
    set_voice_update_listener
  end

  def set_ready_listener
    @bot.ready do |event|
      puts "Logged in as #{@bot.profile.username} (ID:#{@bot.profile.id}) | #{@bot.servers.size} servers"
    end
  end

  def set_voice_update_listener
    @bot.voice_state_update do |event|
      if voice_join?(event)
        VoiceStateUpdate::Join.new(event).perform
      elsif voice_leave?(event) && no_users?(event)
        VoiceStateUpdate::Leave.new(event).perform
      end
    end
  end
end