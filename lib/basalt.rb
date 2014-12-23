require 'basalt/version'
require 'fileutils'
require 'docopt'

module Basalt
  DOC =
%Q(usage: %<binname>s new NAME [--use-modules] [--use-git]
       %<binname>s init [--use-modules]
       %<binname>s modules [<argv>...]
       %<binname>s sniff
)

  def self.run(rootfilename, argv)
    doc = DOC % ({ binname: rootfilename })

    data = Docopt.docopt(doc, argv: argv, version: VERSION, help: false)

    unless data['<command>']
      data = Docopt.docopt(doc, argv: argv, version: VERSION, help: true)
    end

    if data['new']
      name = data['NAME']
      FileUtils::Verbose.mkdir_p(name)
      Dir.chdir(name) do
        require 'basalt/project'
        Basalt::Project.init use_modules: data['--use-modules'], use_git: data['--use-git']
      end
    elsif data['init']
      require 'basalt/project'
      Basalt::Project.init use_modules: data['--use-modules']
    elsif data['modules']
      require 'basalt/modules'
      Basalt::Modules.run(rootfilename, argv)
    elsif data['sniff']
      require 'basalt/project_config'
      require 'basalt/basaltmods'
      require 'json'
      if Basalt::BasaltMods.exist?
        STDERR.puts "#{Dir.getwd} is a BasaltMods Project."
        context = BasaltMods.load_project_file
        STDOUT.puts JSON.pretty_generate(context.to_h)
      elsif Basalt::ProjectConfig.exist?
        STDERR.puts "#{Dir.getwd} is a Basalt Project."
        config = Basalt::ProjectConfig.get
        STDOUT.puts JSON.pretty_generate(config)
      else
        abort 'This does not appear to be a Basalt Project.'
      end
    end
  end
end
