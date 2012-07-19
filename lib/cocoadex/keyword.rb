
require 'fileutils'

module Cocoadex
  class Keyword
    attr_reader :term, :type, :docset, :url
    attr_accessor :fk, :id

    DATA_PATH = File.expand_path("~/.cocoadex/data/store.blob")
    SEPARATOR = "--__--"
    CLASS_METHOD_DELIM = '+'
    INST_METHOD_DELIM  = '-'
    CLASS_PROP_DELIM   = '.'
    SCOPE_CHARS = [CLASS_PROP_DELIM,CLASS_METHOD_DELIM,INST_METHOD_DELIM]

    def self.datastore
      @store ||= []
    end

    def self.find text
      if (text.split(//u) & SCOPE_CHARS).size == 1
        scope = SCOPE_CHARS.detect {|c| text.include? c }
        class_name, term = text.split(scope)
        find_with_scope scope, class_name, term
      else
        keys = datastore.select {|k| k.term.start_with? text }
        if key = keys.detect {|k| k.term == text}
          keys = [key]
        end
        untokenize(keys)
      end
    end

    def self.find_with_scope scope, class_name, term
      if class_key = datastore.detect {|k| k.term == class_name }
        klass = untokenize([class_key]).first
        case scope
        when CLASS_PROP_DELIM
          (klass.methods + klass.properties).select {|m| m.name.start_with? term}
        when CLASS_METHOD_DELIM
          klass.class_methods.select {|m| m.name.start_with? term}
        when INST_METHOD_DELIM
          klass.instance_methods.select {|m| m.name.start_with? term}
        end
      else
        []
      end
    end

    def self.loaded?
      File.exists? DATA_PATH
    end

    def self.read
      $/=SEPARATOR
      File.open(DATA_PATH, "r").each do |object|
        datastore << Marshal::load(object)
      end
    end

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

    def self.untokenize keys
      keys.map do |key|
        case key.type
        when :class
          Cocoadex::Class.new(key.url)
        when :method, :property
          if class_key = datastore.detect {|k| k.id == key.fk}
            klass = Cocoadex::Class.new(class_key.url)
            case key.type
            when :method
              klass.methods.detect {|m| m.name == key.term}
            when :property
              klass.properties.detect {|m| m.name == key.term}
            end
          end
        end
      end
    end

    def self.tokenize_class docset, path, id
      klass = Cocoadex::Class.new(path)
      class_key = Keyword.new(klass.name, :class, docset, path)
      class_key.id = id
      datastore << class_key

      klass.methods.each do |m|
        mkey = Keyword.new(m.name, :method, docset, path)
        mkey.fk = id
        datastore << mkey
      end

      klass.properties.each do |p|
        pkey = Keyword.new(p.name, :property, docset, path)
        pkey.fk = id
        datastore << pkey
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