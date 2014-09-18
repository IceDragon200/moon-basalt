module Basalt
  module Version
    MAJOR = 0
    MINOR = 6
    PATCH = 0
    BUILD = nil
    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join(".").freeze
  end
  VERSION = Version::STRING
end
