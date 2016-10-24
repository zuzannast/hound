module Linter
  class Jshint < Base
    FILE_REGEXP = /.+\.js\z/
    IGNORE_FILENAME = ".jshintignore".freeze

    def file_included?(commit_file)
      jsignore.file_included?(commit_file)
    end

    private

    def config
      Config::Jshint.new(hound_config, owner: build.repo.owner)
    end

    def jsignore
      @jsignore ||= JsIgnore.new(name, hound_config, IGNORE_FILENAME)
    end
  end
end
