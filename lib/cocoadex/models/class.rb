
require 'set'

module Cocoadex
  class Class < Entity
    attr_reader :name, :description, :overview

    def properties
      @properties ||=[]
    end

    def tasks
      @tasks ||= []
    end

    def methods
      @methods ||= ::Set.new
    end

    def parents
      @parents ||= []
    end

    def to_s
      "Class #{name}"
    end

    def print
      puts <<-INFO
      Class: #{name}

        #{description}

        Inherits From: #{parents.join(' > ')}

        Overview:

          #{overview}

        Properties:

      INFO
      properties.each do |prop|
        prop.print
      end
      puts <<-INFO
        Methods:
      INFO
      methods.each do |m|
        m.print
      end
    end

    def parse doc
      @name = doc.css('body a').first['title']
      @description = doc.css('meta#description').first['content']
      # @overview = doc.css(".zClassDescription p.abstract").first.text
      @overview = doc.css(".zClassDescription").first.text.sub("Overview","")
      @parents = doc.css("div.zSharedSpecBoxHeadList").first.css('a').map {|node| node.text}

      parse_properties(doc)
      parse_tasks(doc)
      parse_methods(doc)
    end

    def parse_methods doc
      [:class, :instance].each do |selector|
        nodes = doc.css("div.#{selector}Method")
        # logger.debug(nodes.inspect)
        unless nodes.empty?
          methods.merge(nodes.map {|n| Method.new(selector, n)})
        end
      end
    end

    def parse_properties doc
      @properties = doc.css("div.propertyObjC").map do |prop|
        Property.new(prop)
      end
    end

    def parse_tasks doc
      @tasks = {}
      doc.css('ul.tooltip').each do |list|
        key = list.previous.text
        @tasks[key] = []
        list.css('li span.tooltip').each do |prop|
          @tasks[key] << {
            :name => strip(prop.css('a').first.text),
            :abstract => prop.css('.tooltipicon').first['data-abstract']
          }
        end
      end
      @tasks
    end
  end
end