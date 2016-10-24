require "spec_helper"
require "lib/js_ignore"
require "app/models/config/base"
require "app/models/config/jshint"
require "app/models/config/parser"
require "app/models/config/serializer"

describe Config::Jshint do
  describe "#serialize" do
    it "serializes the parsed content into JSON" do
      commit = stubbed_commit( ".jshintrc" => <<~EOS)
        {
          "maxlen": 80
        }
      EOS
      config = build_config(commit)

      expect(config.serialize).to eq "{\"maxlen\":80}"
    end
  end

  def build_config(commit)
    hound_config = double(
      "HoundConfig",
      commit: commit,
      content: {
        "jshint" => {
          "enabled" => true,
          "config_file" => ".jshintrc",
        },
      },
    )
    Config::Jshint.new(hound_config)
  end
end
