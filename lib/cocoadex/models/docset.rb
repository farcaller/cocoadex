
module Cocoadex
  class DocSet
    attr_reader :platform, :version, :name, :description, :path

    def initialize plist_path
      @doc = Nokogiri::HTML(IO.read(plist_path))
      @path = plist_path
      @name = plist_value 'CFBundleName'
      @platform = plist_value "DocSetPlatformFamily"
      @version = plist_value "DocSetPlatformVersion"
      @description = plist_value "DocSetDescription"
    end

    def inspect
      "<DocSet #{name} @description=#{description} @path=#{path}>"
    end

    private

    def plist_value key
      key_node = @doc.css("dict key").detect do |node|
        node.text == key
      end

      if key_node
        key_node.next.text
      else
        logger.iwarn "Node not found: #{key}"
        nil
      end
    end
  end
end