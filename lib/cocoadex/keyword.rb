
module Cocoadex
  class Keyword
    attr_reader :term, :type, :docset, :url
    attr_accessor :fk, :id

    DATA_PATH = File.join(File.dirname(__FILE__),"..","..","data","store.yaml")

    def self.datastore
      @store ||= []
    end

    def self.find text
      keys = datastore.select {|k| k.term.start_with? text }
      untokenize(keys)
    end

    def self.read
      $/="\n\n"
      File.open(DATA_PATH, "r").each do |object|
        datastore << YAML::load(object)
      end
    end

    def self.write
      File.open(DATA_PATH, "w") do |file|
        datastore.each do |keyword|
          file.puts(YAML.dump(keyword))
          file.puts
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
              entity = klass.methods.detect {|m| m.name == key.term}
            when :property
              entity = klass.properties.detect {|m| m.name == key.term}
            end

            entity.class_name = klass.name
            entity
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