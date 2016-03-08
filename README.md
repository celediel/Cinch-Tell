Tell/Memo Plugin for Cinch
========================
Leave a note for someone not in an IRC channel, to be relayed when they rejoin
the channel

Usage
-----

[![Gem Version](https://badge.fury.io/rb/Cinch-Tell.svg)](https://badge.fury.io/rb/Cinch-Tell)

Install the gem with *gem install Cinch-Tell*, and
add it to your bot like so:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ruby
require 'cinch'
require 'cinch/plugins/tell'

bot = Cinch::Bot.new do
configure do |c|
  c.server = 'your server'
  c.nick = 'your nick'
  c.realname = 'your realname'
  c.user = 'your user'
  c.channels = ['#yourchannel']
  c.plugins.plugins = [Cinch::Plugins::Tell]
end

bot.start
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Contained Commands
------------------

**[tell user message]**

Leave note #{message} for #{user}. They must not be in the channel. Messages
expire after a default of six months.

License
-------

Licensed under The MIT License (MIT)
Please see LICENSE
