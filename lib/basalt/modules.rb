require 'basalt/version'
require 'basalt/config'
require 'basalt/project_config'
require 'docopt'
require 'fileutils'

module Basalt
  module Modules
    DOC =
%Q(usage: %<binname>s modules install NAME... [-h|--hard]
          %<binname>s modules uninstall NAME...
          %<binname>s modules update [NAME...]
          %<binname>s modules list [NAME...]
          %<binname>s modules repair [NAME...]
)

    def self.project_module_path(name)
      projconfig = ProjectConfig.get
      File.join(projconfig['modules_path'], name)
    end

    def self.is_module?(name)
      config = Config.get
      config['module_paths'].each do |path|
        if Dir.entries(path).include?(name)
          return true
        end
      end
      false
    end

    def self.find(name)
      config = Config.get
      config['module_paths'].each do |path|
        pth = File.join(path, name)
        return pth if Dir.exist?(pth)
      end
      nil
    end

    def self.install(name, options = {})
      target = project_module_path(name)

      if File.exist?(target)
        abort "Module #{name} was already installed"
      else
        if modulepath = find(name)
          if options[:hard]
            FileUtils.cp_r(modulepath, target)
          else
            FileUtils.ln_sf(modulepath, target)
          end
          STDOUT.puts "  INSTALL\t#{name} (#{modulepath})"
        else
          STDERR.puts "Module #{name} could not be found"
        end
      end
    end

    def self.uninstall(name)
      projconfig = ProjectConfig.get

      target = File.join(projconfig['modules_path'], name)

      if File.exist?(target)
        FileUtils.rm_rf(target)
        STDOUT.puts "  UNINSTALL\t#{name}"
      else
        STDERR.puts "Module #{name} was not installed"
      end
    end

    def self.update(name)
      STDERR.puts 'modules update has not been implemented'
      #(File.join(projconfig["modules_path"], name))
      #STDOUT.puts "  UPDATE\t#{name}"
    end

    def self.list(name = nil)
    end

    def self.list_all
      config = Config.get
      config['module_paths'].each do |path|
        (Dir.entries(path)-['.', '..']).each do |mod|
          STDOUT.puts mod
        end
      end
    end

    def self.repair(name)
      if is_module?(name)
        if File.symlink?(project_module_path(name))
          uninstall(name)
          install(name)
          STDOUT.puts "  REPAIRED\t#{name}"
        else
          STDERR.puts "#{name} is not a symlink-ed module, please fix it manually"
        end
      else
        STDERR.puts "#{name} is not a module"
      end
    end

    def self.repair_all
      STDERR.puts 'Repairing Modules'
      projconfig = ProjectConfig.get
      modules_path = projconfig['modules_path']
      (Dir.entries(modules_path)-['.','..']).each do |entry|
        repair(entry)
      end
    end

    def self.run(rootfilename, argv)
      config = Config.get

      doc = DOC % ({ binname: rootfilename })

      data = Docopt.docopt(doc, argv: argv, version: VERSION, help: true)

      names = data['NAME']

      if data['install']
        names.each do |name|
          install(name, hard: data['--hard'] || data['-h'])
        end
      elsif data['uninstall']
        names.each do |name|
          uninstall(name)
        end
      elsif data['update']
        names.each do |name|
          update(name)
        end
      elsif data['repair']
        if names.empty?
          repair_all
        else
          names.each do |name|
            repair(name)
          end
        end
      elsif data['list']
        if names.empty?
          list_all
        else
          names.each do |name|
            list(name)
          end
        end
      end
    end
  end
end
