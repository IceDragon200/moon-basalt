require 'basalt'

module Basalt #:nodoc:
  module Cli
    def self.run(*args, &block)
      Basalt.run(*args, &block)
    rescue Docopt::Exit => ex
      abort ex.message
    end
  end
end
