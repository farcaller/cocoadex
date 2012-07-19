
require 'erb'
require 'bri'
require 'cocoadex/version'
require 'cocoadex/templates'
require 'cocoadex/models/docset'
require 'cocoadex/models/element'
require 'cocoadex/models/entity'
require 'cocoadex/models/method'
require 'cocoadex/models/property'
require 'cocoadex/models/class'
require 'cocoadex/parser'
require 'cocoadex/keyword'
require 'ext/nil'
require 'nokogiri'
require 'term/ansicolor'

module Cocoadex

  DEFAULT_WIDTH = 72

  # output documentation text for a given search term
  def self.search term, load_first=false
    term = term.strip
    unless term.empty?
      objects = Keyword.find(term)
      if objects.size == 0
        puts "No matches found"
      elsif objects.size == 1 or load_first
        puts objects.first.print
      else
        template = Cocoadex::Templates::MULTIPLE_CHOICES
        puts ERB.new(template, nil, '<>').result(binding)
      end
    end
  end

  # The maximum line width
  def self.width
    @width || DEFAULT_WIDTH
  end

  def self.width= width
    @width = width
  end

  # add leading whitespace to lines
  def self.indent text, level=2
    text.split("\n").collect {|row| "#{' '*level}#{row}"}.join("\n" )
  end

  # add leading whitespace to lines, increasing indent after
  # the first line
  def self.trailing_indent text, base_level=2, inside_level=4
    text.split("\n").each_with_index.collect do |row, index|
      level = index == 0 ? base_level : inside_level
      "#{' '*level}#{row}"
    end.join("\n")
  end
end