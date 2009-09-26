module WTTH
  private
  CONFIG_PATH = File::expand_path('~/.wtth.yml')
  # set the defaults
  CONFIG = {:player_list_uri => 'http://20cent.hvzsource.com/players.php'}

  def self.load_config
    if File.exists?(CONFIG_PATH)
      File.open(CONFIG_PATH) do |file|
        CONFIG.merge!(YAML::load(file.read))
      end
    end
  end

  def self.save_config
    File.open(CONFIG_PATH, 'w') do |file|
      file.write(YAML::dump(CONFIG))
    end
  end
end
