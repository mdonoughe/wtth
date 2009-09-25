require 'net/http'
require 'rubygems'
require 'nokogiri'
require 'twitter'
require 'yaml'

APP_TOKEN = 'HgPXVDITRITul4peTLkyg'
APP_SECRET = 'iLoBnhZF3YDki5k4l09hptgg9SaRJkOYEyzsk1n0'
$config = {:player_list_uri => 'http://20cent.hvzsource.com/players.php'}

def get_new_zombies
  to_welcome = []

  puts "fetching from hvzsource"

  uri = URI.parse($config[:player_list_uri])
  preq = Net::HTTP::Post.new(uri.path)
  preq.set_form_data({'faction' => 'h', 'sort_by' => 'kd', 'order' => 'd', 'show_killed' => '1', 'submit' => 'Refresh'}, '&')

  req = Net::HTTP.new(uri.host, uri.port)
  req.start do |http|
    http.request(preq) do |resp|
      doc = Nokogiri::HTML(resp.read_body)
      # hvzsource produces some malformed html, so we can't use rows
      # the table is <name> | horde | <tod>
      cells = doc.xpath('//form/table//td')
      ((cells.length - 3) / 3).times do |i|
        name = cells[i * 3 + 3].content
        tod = cells[i * 3 + 5].content
        kill = {:name => name, :tod => tod}
        break if kill == $config[:last_welcomed]
        to_welcome << kill
      end
    end
  end
  return to_welcome
end

def tweet( message )
  oauth = Twitter::OAuth.new(APP_TOKEN, APP_SECRET)
  oauth.authorize_from_access($config[:access_token], $config[:access_secret])
  twitter = Twitter::Base.new(oauth)
  twitter.update(message)
end

# update configuration
config_path = File::expand_path('~/.wtth.yml')
if File.exists?(config_path)
  File.open(config_path) do |file|
    $config.merge!(YAML::load(file.read))
  end
end

# the presense of backlog indicates that we have at least one tweet worth of
# new zombies fetched already
to_welcome = $config[:backlog]
to_welcome = get_new_zombies if to_welcome == nil

if to_welcome != []
  this_batch = []
  recovery = []
  size = 0
  last_welcomed = nil

  # get the least recent kills, no more than 140 characters worth
  until size > 140 or to_welcome.empty?
    zombie = to_welcome.last
    size += zombie[:name].length
    size += 2 if this_batch.length > 0
    if size <= 140
      this_batch << zombie[:name]
      last_welcomed = zombie
      recovery << to_welcome.pop
    end
  end

  # can we avoid hvzsource next run?
  size = 0
  to_welcome.reverse_each do |zombie|
    size += 2 unless size == 0
    size += zombie[:name].length
    break if size >= 140
  end
  if size >= 140
    $config[:backlog] = to_welcome
  else
    $config[:backlog] = nil
  end

  # welcome with the most recent first so things are in order on twitter
  this_batch.reverse!

  begin
    tweet(this_batch.join(', '))
    # remember where we left off
    $config[:last_welcomed] = last_welcomed
  rescue Twitter::TwitterError
    puts "TwitterError #{$!}"
    # throw the message onto the backlog so we can try again next time
    $config[:backlog] = to_welcome + recovery.reverse
  end
end

# write the config
File.open(config_path, 'w') do |file|
  file.write(YAML::dump($config))
end
