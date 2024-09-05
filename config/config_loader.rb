require 'json'
require 'singleton'

module ConfigLoader

  CONFIG_FILE_PATH = File.expand_path('../config/config.json', __dir__)

  def self.config
    @config ||= load_config
  end

  private

  def self.load_config
    JSON.parse(File.read(CONFIG_FILE_PATH))
  rescue Errno::ENOENT => e
    raise "Configuration file not found: #{e.message}"
  rescue JSON::ParserError => e
    raise "Error parsing configuration file: #{e.message}"
  end
end