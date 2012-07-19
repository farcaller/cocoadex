
module Cocoadex
  class Class < Entity
    class Method
      attr_reader :name, :abstract, :declaration, :scope,
        :discussion, :declared_in, :availability, :parameters,
        :return_value

      attr_accessor :class_name

      class Parameter
        attr_reader :name, :description

        def initialize name, description
          @name, @description = name, description
        end

        def print
          "#{name} - #{description}"
        end
      end

      def parameters
        @parameters ||= []
      end

      def initialize type, node
        @type = type
        @name = node.css("h3.#{type}Method").first.text
        logger.debug("parsing #{@type} method #{@name}")
        @abstract = node.css(".abstract").first.text
        @declaration = node.css(".declaration").first.text

        decl_nodes = node.css(".declaredIn code.HeaderFile")
        if decl_nodes.size > 0
          @declared_in = decl_nodes.first.text
        end

        if discussion_node = node.css(".discussion > p") and discussion_node.length > 0
          @discussion = discussion_node.first.text
        end

        if return_nodes = node.css(".return_value p") and return_nodes.size > 0
          @return_value = return_nodes.first.text
        end

        ava_nodes = node.css(".availability > ul > li")
        if ava_nodes.size > 0
          @availability = ava_nodes.first.text
        end

        if parameters = node.css(".parameters") and parameters.length > 0
          @parameters = []
          parameters.first.css("dt").each do |param|
            name_nodes = param.css("em")
            if name_nodes.size > 0
              name = param.css("em").first.text
              description = param.next.css("p").first.text
              @parameters << Parameter.new(name, description)
            end
          end
        end
      end

      def to_s
        "Method #{name}"
      end

      def print
        puts <<-PRINT
          Declared in: #{declared_in}

          #{declaration}
              #{print_parameters}
            Returns: #{return_value}
            #{abstract}
            #{availability}
        PRINT
      end

      def print_parameters
        parameters.map {|pm| pm.print}.join("\n              ") if parameters
      end
    end
  end
end