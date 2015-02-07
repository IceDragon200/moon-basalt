require 'basalt/packages'
require 'basalt/project'
require 'basalt/version'
require 'fileutils'
require 'docopt'

module Basalt
  DOC = %Q(USAGE:
  %<binname>s new NAME
  %<binname>s init
  %<binname>s install
  %<binname>s update
  %<binname>s sync
  %<binname>s package [<argv>...]
)

  def self.run(rootfilename, argv)
    doc = DOC % ({ binname: rootfilename })

    data = Docopt.docopt(doc, argv: argv, version: VERSION, help: false)

    unless data['<command>']
      data = Docopt.docopt(doc, argv: argv, version: VERSION, help: true)
    end

    packages = Basalt::Packages.new

    if data['new']
      name = data['NAME']
      FileUtils::Verbose.mkdir_p(name)
      Dir.chdir(name) do
        Basalt::Project.init
      end
    elsif data['init']
      Basalt::Project.init
    elsif data['install']
      packages.install
    elsif data['update']
      packages.update
    elsif data['sync']
      packages.sync
    elsif data['package']
      packages.run(rootfilename, argv)
    end
  end
end
