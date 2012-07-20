#!/usr/bin/env sh
#
# cocoadex_completion.sh
#
# Bash completion for Cocoa classes
# Install by adding the following to your .bash_profile:
#
# complete -C /path/to/cocoadex_completion.sh -o default cocoadex

/usr/bin/env ruby <<-EORUBY

require 'cocoadex'

class TagCompletion
  def initialize(command)
    @command = command
  end

  def matches
    tags.select do |tag|
      tag[0, typed.length] == typed
    end
  end

  def typed
    @command[/\s(.+?)$/, 1] || ''
  end

  def tags
    @tags ||= Cocoadex::Keyword.tags
  end
end

puts TagCompletion.new(ENV["COMP_LINE"]).matches

EORUBY
