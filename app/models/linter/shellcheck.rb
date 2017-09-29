# frozen_string_literal: true
module Linter
  class Shellcheck < Base
    FILE_REGEXP = /.+(\.sh|\.zsh|\.bash)\z/
  end
end
