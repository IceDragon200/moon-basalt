require "basalt/version"
require "fileutils"
require "docopt"

module Basalt
  DOC =
%Q(usage: %<binname>s new NAME [--use-modules] [--use-git]
          %<binname>s init [--use-modules]
          %<binname>s modules [<argv>...]
)

  def self.run(rootfilename, argv)
    doc = DOC % ({ binname: rootfilename })

    data = Docopt.docopt(doc, argv: argv, version: VERSION, help: false)

    unless data["<command>"]
      data = Docopt.docopt(doc, argv: argv, version: VERSION, help: true)
    end

    if data["new"]
      name = data["NAME"]
      FileUtils::Verbose.mkdir_p(name)
      Dir.chdir(name) do
        require "basalt/project"
        Basalt::Project.init use_modules: data["--use-modules"], use_git: data["--use-git"]
      end
    elsif data["init"]
      require "basalt/project"
      Basalt::Project.init use_modules: data["--use-modules"]
    elsif data["modules"]
      require "basalt/modules"
      Basalt::Modules.run(rootfilename, argv)
    end
  end
end
