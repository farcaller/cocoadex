
require 'fileutils'

module Cocoadex
  class Keyword
    attr_reader :term, :type, :docset, :url
    attr_accessor :fk, :id

    # Cache storage location
    DATA_PATH = File.expand_path("~/.cocoadex/data/store.blob")

    SEPARATOR = "--__--"
    CLASS_METHOD_DELIM = '+'
    INST_METHOD_DELIM  = '-'
    CLASS_PROP_DELIM   = '.'
    SCOPE_CHARS = [CLASS_PROP_DELIM,CLASS_METHOD_DELIM,INST_METHOD_DELIM]

    def self.datastore
      @store ||= []
    end

    # Search the cache for matching text
    def self.find text
      if scope = SCOPE_CHARS.detect {|c| text.include? c }
        class_name, term = text.split(scope)
        find_with_scope scope, class_name, term
      else
        keys = datastore.select {|k| k.term.start_with? text }
        if key = keys.detect {|k| k.term == text }
          keys = [key]
        end
        untokenize(keys)
      end
    end

    # Find matches for term within a given class
    def self.find_with_scope scope, class_name, term
      if class_key = datastore.detect {|k| k.term == class_name }
        klass = untokenize([class_key]).first
        list  = case scope
          when CLASS_PROP_DELIM
            klass.methods + klass.properties
          when CLASS_METHOD_DELIM
            klass.class_methods
          when INST_METHOD_DELIM
            klass.instance_methods
        end
        list.select {|m| m.name.start_with? term}
      else
        []
      end
    end

    # Are any docsets loaded into the cache?
    def self.loaded?
      File.exists? DATA_PATH
    end

    # Read a serialized cache file into an Array
    def self.read
      $/=SEPARATOR
      File.open(DATA_PATH, "r").each do |object|
        datastore << Marshal::load(object)
      end
    end

    # Write a cache Array as a serialized file
    def self.write
      unless File.exists? File.dirname(DATA_PATH)
        FileUtils.mkdir_p File.dirname(DATA_PATH)
      end
      File.open(DATA_PATH, "w") do |file|
        datastore.each do |keyword|
          file.print(Marshal.dump(keyword))
          file.print SEPARATOR
        end
      end
    end

    # Create Cocoadex model objects for Keyword references
    def self.untokenize keys
      keys.map do |key|
        case key.type
        when :class
          Cocoadex::Class.new(key.url)
        when :method, :property
          if class_key = datastore.detect {|k| k.id == key.fk}
            klass = Cocoadex::Class.new(class_key.url)
            list = key.type == :method ? klass.methods : klass.properties
            list.detect {|m| m.name == key.term}
          end
        end
      end
    end

    # Find all searchable keywords in a class and add to cache
    def self.tokenize_class docset, path, id
      klass = Cocoadex::Class.new(path)
      class_key = Keyword.new(klass.name, :class, docset, path)
      class_key.id = id
      datastore << class_key

      {:method => klass.methods, :property => klass.properties}.each do |type,list|
        list.each do |item|
          item_key = Keyword.new(item.name, type, docset, path)
          item_key.fk = id
          datastore << item_key
        end
      end
    end

    def initialize term, type, docset, url
      @term, @type, @docset, @url = term, type, docset, url
    end

    def inspect
      "<Keyword#{type} @term=#{term}>"
    end

    def to_s
      "#{type} => #{term}"
    end
  end
end