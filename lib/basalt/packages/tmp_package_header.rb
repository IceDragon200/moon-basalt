require 'ostruct'

module Basalt
  class Packages
    class PackageHeader
      attr_accessor :name
      attr_accessor :config
      attr_accessor :require_contents

      def deps
        (@config && @config[:deps]) || []
      end

      def setup_require_contents
        basaltfilename = '_basalt.rb'

        c = @require_contents = ''
        if @config && (require_name = @config[:require])
          c << "### package(.yml): #{name}/#{require_name}\n"
          if File.exist?(require_name)
            c << File.read(require_name)
          else
            abort "#{name} stated that its :require was '#{require_name}', however the file was not found"
          end
        elsif File.exist?(basaltfilename)
          c << "### package: #{name}/#{basaltfilename}\n"
          c << File.read(basaltfilename)
        elsif File.exist?('load.rb')
          c << "### package: #{name}\n"
          c << "require '#{name}/load'\n"
        end
        c << "\n" unless c.end_with?("\n")
      end

      def load_from_config_file(filename)
        @config = OpenStruct.new(YAML.load_file(filename))
        setup_require_contents
      end
    end
  end
end
