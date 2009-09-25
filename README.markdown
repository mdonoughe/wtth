# Welcome to the Horde

This is a program that watches [HVZ Source](http://humansvszombies.org/) and posts messages to [Twitter](http://twitter.com/) when people are zombified. See [@wtthumd](http://twitter.com/wtthumd) for an example(game starts 2009-09-27 at about 22:00).

Please only run one WTTH or similar per game. Check to see if your game already has one before starting your own. Nothing is gained by running duplicates, and it wastes the resources of Twitter and HVZ Source.

## Installation
WTTH is written in [Ruby](http://www.ruby-lang.org/) and requires the [nokogiri](http://nokogiri.rubyforge.org/) and [twitter](http://twitter.rubyforge.org/) [gems](http://docs.rubygems.org/).

After you've got everything installed, run `twitterinit.rb` to give the program access to a Twitter account. I'd suggest not using your usual Twitter account for this.

Running `twitterinit.rb` will create a file called `.wtth.yml` in your home directory. You'll want to open that and change `player_list_uri` to point at the correct HVZ Source page for your game.

You'll probably want to make some sort of cron job to run `wtth.rb`. It makes at most one request to HVZ Source and posts at most one message to Twitter per run. Set this to a responsible interval. You can probably get away with as low as once a minute, but that's completely unnecessary in my opinion.

Please remember not to have the cron job running when the game is not in session.
