require 'rubygems'
require 'net/http'
require 'nokogiri'
require 'twitter'
require 'yaml'

wtth_path = File.join(File.expand_path(File.dirname(__FILE__)), 'wtth')
require File.join(wtth_path, 'config')
require File.join(wtth_path, 'twitter')

module WTTH
  VERSION = '1.2.1'

  def self.init
    load_config
    twitter_init
  end

  def self.update
    load_config

    unless twitter_is_authorized?
      puts 'You have not yet authorized WTTH to access Twitter.'
      puts 'Please run `wtth init` first'
      exit 1
    end

    # get new zombies and zombies that weren't reported last time
    to_welcome = CONFIG[:backlog]
    if to_welcome == nil
      to_welcome = get_new_zombies
    elsif to_welcome.join(', ').length < 140
      to_welcome = get_new_zombies + to_welcome
    end

    if to_welcome != []
      this_batch = []
      recovery = []
      size = 0

      # get the least recent kills, no more than 140 characters worth
      until size > 140 or to_welcome.empty?
        zombie = to_welcome.last
        size += zombie.length
        size += 2 if this_batch.length > 0
        if size <= 140
          this_batch << zombie
          recovery << to_welcome.pop
        end
      end

      # remember who we haven't reported
      CONFIG[:backlog] = to_welcome

      # welcome with the most recent first so things are in order on twitter
      this_batch.reverse!

      begin
        tweet(this_batch.join(', '))
      rescue Twitter::TwitterUnavailable
        puts "TwitterUnavailable #{$!}"
        # throw the message onto the backlog so we can try again next time
        CONFIG[:backlog] = to_welcome + recovery.reverse
      rescue Twitter::TwitterError
        puts "TwitterError #{$!}"
        # throw the message onto the backlog so we can try again next time
        CONFIG[:backlog] = to_welcome + recovery.reverse
      end
    end

    save_config
  end
end
