module SmartRubyPlug
  class Config
    SETTINGS_FILE = 'config/settings.yml'.freeze
    SETTINGS_FILE_FOR_TEST = 'config/settings.example.yml'.freeze

    @@settings = nil

    def self.parsed_settings
      if defined?(RSpec)
        @@settings ||= self.load_yaml(SETTINGS_FILE_FOR_TEST)
      else
        @@settings ||= self.load_yaml(SETTINGS_FILE)
      end
    end

    def self.load_yaml(file_path)
      YAML.safe_load(File.read(file_path), symbolize_names: true)
    end
  end
end

