require 'rubygems'
require 'twitter'
require 'yaml'

APP_TOKEN = 'HgPXVDITRITul4peTLkyg'
APP_SECRET = 'iLoBnhZF3YDki5k4l09hptgg9SaRJkOYEyzsk1n0'
# set the uri here for convenience during installation
$config = {:player_list_uri => 'http://20cent.hvzsource.com/players.php'}
config_path = File::expand_path('~/.wtth.yml')
if File.exists?(config_path)
  File.open(config_path) do |file|
    $config.merge!(YAML::load(file.read))
  end
end

oauth = Twitter::OAuth.new(APP_TOKEN, APP_SECRET)
if $config[:access_token] == nil or $config[:access_secret] == nil
  puts "Please go to #{oauth.request_token.authorize_url} and enter the PIN number here:"
  oauth.authorize_from_request(oauth.request_token.token, oauth.request_token.secret, gets.to_i)
  $config[:access_token] = oauth.access_token.token
  $config[:access_secret] = oauth.access_token.secret
end

File.open(config_path, 'w') do |file|
  file.write(YAML::dump($config))
end
