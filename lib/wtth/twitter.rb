module WTTH
  private
  APP_TOKEN = 'HgPXVDITRITul4peTLkyg'
  APP_SECRET = 'iLoBnhZF3YDki5k4l09hptgg9SaRJkOYEyzsk1n0'

  def self.tweet( message )
    oauth = Twitter::OAuth.new(APP_TOKEN, APP_SECRET)
    oauth.authorize_from_access(CONFIG[:access_token], CONFIG[:access_secret])
    twitter = Twitter::Base.new(oauth)
    twitter.update(message)
  end

  def self.twitter_is_authorized?
    return (CONFIG[:access_token] != nil and CONFIG[:access_secret] != nil)
  end

  def self.twitter_init
    oauth = Twitter::OAuth.new(APP_TOKEN, APP_SECRET)
    puts "Please go to #{oauth.request_token.authorize_url} and enter the PIN number here:"
    oauth.authorize_from_request(oauth.request_token.token, oauth.request_token.secret, STDIN.gets.to_i)
    CONFIG[:access_token] = oauth.access_token.token
    CONFIG[:access_secret] = oauth.access_token.secret

    save_config
  end
end
