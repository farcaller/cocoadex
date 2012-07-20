
module Cocoadex
  class DocSetHelper

    DATA_PATH = File.expand_path("~/.cocoadex/data/docsets.blob")

    ROOT_PATHS = [
      '~/Library/Developer/Documentation/DocSets',
      '~/Library/Developer/Shared/Documentation/DocSets',
      '/Applications/Xcode.app/Contents/Developer/Documentation/DocSets',
      '/Applications/Xcode.app/Contents/Developer/Platforms/*/Developer/Documentation/DocSets'
    ]

    def self.docset_paths
      @paths ||= begin
        ROOT_PATHS.map { |path| Dir.glob(path+'/*/') }.flatten
      end
    end

    def self.search_and_index paths=docset_paths
      docsets = []
      paths.map do |path|
        if docset = Parser.parse(path)
          docsets << docset
        end
      end

      if docsets.size > 0
        Keyword.write(:overwrite)
        write(docsets)
      end
      logger.info "Done! #{docsets.size} DocSet#{docsets.size == 1 ? '':'s'} indexed."
    end

    def indexed_docsets
      @docsets ||= Serializer.read(DATA_PATH)
    end

    def self.read
      @docsets = Serializer.read(DATA_PATH)
    end

    def self.write docsets
      @docsets = docsets
      Serializer.write(DATA_PATH, docsets, :overwrite)
    end
  end
end