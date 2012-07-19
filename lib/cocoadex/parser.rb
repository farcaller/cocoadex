
module Cocoadex
  class Parser

    IGNORED_DIRS = [
      'codinghowtos', 'qa',
      'featuredarticles','navigation',
      'recipes','releasenotes',
      'samplecode','Conceptual',
      'technotes','History',
      'Introduction','GettingStarted'
    ]

    IGNORED_FILES = [
      'RevisionHistory','Introduction'
    ]

    def self.ignored? path
      (path.split('/') & IGNORED_DIRS).size > 0 or
      IGNORED_FILES.include?(File.basename(path).sub('.html','')) or
      (File.basename(path) == 'index.html' && File.exist?(File.join(File.dirname(path),'Reference')))
    end

    def self.parse docset_path
      logger.debug "Parsing docset..."
      plist = File.join(docset_path,"Contents", "Info.plist")
      if File.exist? plist
        docset = DocSet.new(plist)
        logger.info docset.inspect
        files = Dir.glob(docset_path+"/**/*.html")
        files.reject! {|f| ignored?(f) }

        files.each_with_index do |f,index|
          logger.debug "  Parsing path: #{f}"
          doc = Nokogiri::HTML(IO.read(f))
          title_nodes = doc.css("#IndexTitle")
          unless title_nodes.size == 0
            title = title_nodes.first['content']
            if title.include? "Deprecated"
              next
            elsif title.include? "Class Reference" or title.include? "Protocol Reference"
              logger.info "    Creating #{title}"
              Keyword.tokenize_class docset.name, f, index
            end
          end
        end

        logger.info "Tokens Indexed: #{Keyword.datastore.size}"
        Keyword.write
      end
    end
  end
end