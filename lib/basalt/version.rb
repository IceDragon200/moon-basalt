module Basalt #:nodoc:
  module Version
    MAJOR, MINOR, TEENY, PATCH = 0, 11, 0, nil
    STRING = [MAJOR, MINOR, TEENY, PATCH].compact.join('.').freeze
  end
  VERSION = Version::STRING

  def self.print_version
    STDERR.puts('basalt ' << VERSION)
  end
end
