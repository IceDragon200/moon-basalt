module Basalt
  module Version
    MAJOR = 0
    MINOR = 7
    TEENY = 3
    PATCH = nil
    STRING = [MAJOR, MINOR, TEENY, PATCH].compact.join('.').freeze
  end
  VERSION = Version::STRING
end
