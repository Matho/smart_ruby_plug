module SmartRubyPlug
  class Config
    SETTINGS_FILE = 'config/settings.yml'.freeze

    @@settings = nil

    def self.parsed_settings
      @@settings ||= YAML.safe_load(File.read(SETTINGS_FILE), symbolize_names: true)
    end
  end
end

