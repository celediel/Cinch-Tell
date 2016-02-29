Tell/Memo Plugin for Cinch
========================
Leave a note for someone not in an IRC channel, to be relayed when they rejoin
the channel

Usage
-----

Until I figure out how to make it into a gem, download the .rb file, and place 
it in a subdirectory of your bot entitled 
`plugins` then require it via `require_relative`. 
Add it to your bot like so:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ruby
require 'cinch'
require_relative 'plugins/tell.rb'

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
