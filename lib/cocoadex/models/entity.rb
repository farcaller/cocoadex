
module Cocoadex
  class Entity

    def initialize path
      text     = clean(IO.read(path))
      document = Nokogiri::HTML(text)
      parse(document)
    end

    def print
      raise "print() not defined for #{self.class}"
    end

    def clean text
      text.gsub(/(\n|\t|\r)/, ' ').gsub(/>\s*</, '><').squeeze(' ')
    end

    def strip text
      text.gsub("&#xA0;&#xA0;","")
    end
  end
end