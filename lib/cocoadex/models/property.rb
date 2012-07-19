
module Cocoadex
  class Property
    attr_reader :name, :abstract, :declaration, :discussion, :availability

    attr_accessor :class_name

    def initialize node
      @name = node.css("h3.method_property").first.text
      logger.debug("Adding property: #{@name}")

      if abs = node.css(".abstract") and abs.length > 0
        @abstract = abs.first.text
      end

      if decl = node.css(".declaration") and decl.length > 0
        @declaration = decl.first.text
      end

      if disc = node.css(".discussion > p") and disc.length > 0
        @discussion = disc.first.text
      end

      if ava_nodes = node.css(".availability > ul > li") and ava_nodes.size > 0
        @availability = ava_nodes.first.text
      end
    end

    def to_s
      "Property #{name}"
    end

    def print
      puts <<-PRINT
        Declared in: #{class_name || ''}

        #{name}
          #{abstract}
          #{availability}

      PRINT
    end
  end
end