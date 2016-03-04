#!/usr/bin/env ruby
# encoding=utf-8

require 'sequel'
require 'time'
require 'time_diff'
require 'facets/time/shift'

# These are all very annoying.
# rubocop:disable Metrics/LineLength, Metrics/ClassLength, Metrics/CyclomaticComplexity
# rubocop:disable Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/AbcSize

module Cinch
  module Plugins
    # Leaving messages and things
    class Tell
      include Cinch::Plugin
      listen_to :join, method: :check_tells
      listen_to :nick, method: :check_tells

      # I don't actually know if this does anything with cinch
      # but I keep anything that's not an actual command private
      private

      def initialize(*args)
        super
        # TODO: make database name based on bot nick
        # or configuration variable
        @db = Sequel.sqlite('riria.db')
        # Create the tables if they don't exist
        @db.create_table? :tells do
          primary_key :id
          String :from_user
          String :to_user
          String :message
          Float :time
        end
        @db = purge_ancients(@db)
      end

      def read_tells(nick)
        # read the database and return array of tells for specified nick
        tells = @db[:tells]
        ret = tells.where(to_user: nick).all
        return [] if ret.empty?
        ret
      end

      def parse_tells(tell)
        # ready tell for telling
        from_nick = tell[:from_user]
        msg = tell[:message]
        msg_when = tell[:time]
        timediff = Time.diff(Time.at(msg_when), Time.now)
        puts "when: #{msg_when}, now: #{Time.now}, timediff: #{timediff}"
        output = "#{from_nick} wanted to tell you '#{msg}', "
        # lots of unless, could use timediff[:diff] but it's ugly
        ago_str = ''
        ago_str = "#{timediff[:year]} years, " unless timediff[:year].zero?
        ago_str << "#{timediff[:month]} months, " unless timediff[:month].zero?
        ago_str << "#{timediff[:week]} weeks, " unless timediff[:week].zero?
        ago_str << "#{timediff[:day]} days, " unless timediff[:day].zero?
        ago_str << "#{timediff[:hour]} hours, " unless timediff[:hour].zero?
        ago_str << "#{timediff[:minute]} minutes, " unless timediff[:minute].zero?
        ago_str << 'and ' unless ago_str.empty?
        ago_str << "#{timediff[:second]} seconds " unless timediff[:second].zero?
        ago_str << 'ago.' unless ago_str.empty?
        ago_str = 'an undetermined amount of time ago.' if ago_str.empty?
        output << ago_str
      end

      def purge_ancients(db)
        # purge any messages older than x date
        # TODO: make this a config variable
        purge_date = Time.now.shift(-6, :months)
        db[:tells].where('time < ?', purge_date.to_f).delete
        db
      end

      def add_tell(nick, msg, from)
        # add a tell to the database
        t = Time.now.to_f
        @db[:tells].insert(to_user: nick, from_user: from, message: msg, time: t)
      end

      public

      def check_tells(m)
        # Listen to join and nick changes, and check if user has any waiting
        # memos in the database. Might listen to all messages and check if
        # speaking user has any waiting memos, for people who go away
        # but don't change their nick, but I'm not sure if I want to query
        # the database at every IRC message in every channel
        tells = read_tells(m.user.nick.downcase)
        return if tells.empty?
        r = parse_tells(tells.first)
        r = r.prepend("#{m.user.nick}: ") unless m.channel.nil?
        m.reply(r)
        if tells.length > 1
          tells.each_with_index do |i, j|
            next if j == 0 # Skip the first message because it was already sent
            User(i[:to_user]).send(parse_tells(i))
          end
        end
        @db[:tells].where(to_user: m.user.nick.downcase).delete
      end

      match(/tell(?: (.+))?/, method: :irc_tell)
      def irc_tell(m, q)
        nick = q.split(' ')[0]
        msg = q.split(' ')[1..-1].join(' ')
        if m.channel.has_user?(nick)
          m.reply("#{nick} is here right now, tell them yourself!")
          return
        end
        add_tell(nick.downcase, msg, m.user.nick)
        m.reply("Okay I'll let #{nick} know the next time they join the channel.")
      end
    end
  end
end

# vim:tabstop=2 softtabstop=2 expandtab shiftwidth=2 smarttab foldmethod=syntax:
