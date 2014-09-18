require "basalt/version"
require "basalt/config"
require "basalt/project_config"
require "docopt"
require "fileutils"

module Basalt
  module Modules
    DOC =
%Q(usage: %<binname>s modules install [NAME...] [-h|--hard]
          %<binname>s modules uninstall [NAME...]
          %<binname>s modules update [NAME...]
          %<binname>s modules list [NAME...]
)

    def self.find(name)
      config = Config.get
      config["module_paths"].each do |path|
        if Dir.entries(path).include?(name)
          return File.join(path, name)
        end
      end
      nil
    end

    def self.install(name, options={})
      projconfig = ProjectConfig.get

      target = File.join(projconfig["modules_path"], name)

      if File.exist?(target)
        abort "Module #{name} was already installed"
      else
        if modulepath = find(name)
          if options[:hard]
            FileUtils::Verbose.cp_r(modulepath, target)
          else
            FileUtils::Verbose.ln_s(modulepath, target)
          end
        else
          abort "Module #{name} could not be found"
        end
      end
    end

    def self.uninstall(name)
      projconfig = ProjectConfig.get

      target = File.join(projconfig["modules_path"], name)

      if File.exist?(target)
        FileUtils::Verbose.rm_rf(target)
      else
        abort "Module #{name} was not installed"
      end
    end

    def self.update(name)
      STDERR.puts "modules update has not been implemented"
      #(File.join(projconfig["modules_path"], name))
    end

    def self.list(name)
      if name
      else
        config = Config.get
        config["module_paths"].each do |path|
          (Dir.entries(path)-[".", ".."]).each do |mod|
            STDOUT.puts mod
          end
        end
      end
    end

    def self.run(rootfilename, argv)
      config = Config.get

      doc = DOC % ({ binname: rootfilename })

      data = Docopt.docopt(doc, argv: argv, version: VERSION, help: true)

      names = data["NAME"]

      if data["install"]
        names.each do |name|
          install(name, hard: data["--hard"] || data["-h"])
        end
      elsif data["uninstall"]
        names.each do |name|
          uninstall(name)
        end
      elsif data["update"]
        names.each do |name|
          update(name)
        end
      elsif data["list"]
        names.each do |name|
          list(name)
        end
      end
    end
  end
end
