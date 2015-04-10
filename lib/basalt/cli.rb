require 'basalt'

module Basalt
  module Cli
    class RunContext
      class NullOut
        def write(*args, &block)
        end

        def puts(*args, &block)
        end

        def <<(*args, &block)
        end
      end

      attr_reader :options
      attr_reader :log

      def initialize(options = {})
        @log = STDERR
        @null_log = NullOut.new
        @options = options
      end

      def [](key)
        @options[key]
      end

      def verbose
        if @options[:verbose]
          yield @log if block_given?
          return @log
        end
        return @null_log
      end
      alias :v :verbose

      def to_h
        options
      end
      alias :to_hash :to_h
    end

    DOC = %Q(Usage:
  %<binname>s new NAME [options]
  %<binname>s init [options]
  %<binname>s install [options]
  %<binname>s update [options]
  %<binname>s sync [options]
  %<binname>s package [options] [<argv>...]

Options:
  -f, --basaltfile=BASALTFILE  basaltfile to load
  -i, --install-method=METHOD  state the default installation-method (ref, copy)
  -v, --verbose                set basalt in verbose mode (very talkative)
)

    def self.unsafe_run(rootfilename, argv)
      doc = DOC % ({ binname: rootfilename })

      data = Docopt.docopt(doc, argv: argv, version: VERSION, help: false)

      unless data['<command>']
        data = Docopt.docopt(doc, argv: argv, version: VERSION, help: true)
      end

      rctx = RunContext.new
      rctx.options[:basaltfile] = data['--basaltfile']
      rctx.options[:install_method] = data['--install-method']
      rctx.options[:verbose] = data['--verbose']
      rctx.verbose.puts "(#{self.name}).options: #{rctx.options}"

      bf = ((bsf = rctx[:basaltfile]) && Basaltfile.new(bsf)) || nil
      packages = Basalt::Packages.new(bf)

      if data['new']
        name = data['NAME']
        FileUtils::Verbose.mkdir_p(name)
        Dir.chdir(name) do
          Basalt::Project.init
        end
      elsif data['init']
        Basalt::Project.init
      elsif data['install']
        packages.install(rctx)
      elsif data['update']
        packages.update(rctx)
      elsif data['sync']
        packages.sync(rctx)
      elsif data['package']
        packages.run(rootfilename, argv, rctx)
      end
    end

    def self.run(*args, &block)
      unsafe_run(*args, &block)
    rescue Docopt::Exit => ex
      abort ex.message
    end
  end
end
