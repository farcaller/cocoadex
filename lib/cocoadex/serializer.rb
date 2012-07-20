
module Cocoadex
  class Serializer
    SEPARATOR = "--__--"

    # Read a serialized cache file into an Array
    def self.read path
      $/=SEPARATOR
      array = []
      File.open(path, "r").each do |object|
        array << Marshal::load(object)
      end
      array
    end

    # Write a cache Array as a serialized file
    def self.write path, array, style
      unless File.exists? File.dirname(path)
        FileUtils.mkdir_p File.dirname(path)
      end

      mode = case style
        when :append then 'a'
        when :overwrite then 'w'
        else
          raise "Unknown file mode: #{style}"
      end

      File.open(path, mode) do |file|
        array.each do |object|
          file.print(Marshal.dump(object))
          file.print SEPARATOR
        end
      end
    end
  end
end