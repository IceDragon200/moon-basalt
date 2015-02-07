module Basalt
  class Packages
    class Repo
      def self.system_repo(config)
        repo = MultiRepo.new
        config.paths.each do |path|
          repo.repos << Repo.new(OpenStruct.new(pkgdir: path))
        end
        repo
      end
    end
  end
end
