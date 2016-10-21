require "faraday"
require "spec/support/helpers/commit_helper"
require "app/services/build_config"
require "app/services/config_class_from_name"
require "app/models/config/base"
require "app/models/config/fetch_error"

class Config::Test < Config::Base
  def serialize
    content.to_yaml
  end

  private

  def parse(file_content)
    YAML.load(file_content)
  end
end

describe BuildConfig do
  context "when there is no config content for the given linter" do
    it "does not raise" do
      hound_config = instance_double(
        "HoundConfig",
        commit: instance_double("Commit", file_content: ""),
        content: {},
      )
      config = BuildConfig.run(hound_config, "test")

      expect { config.serialize }.not_to raise_error
    end
  end

  context "when there is no specified filepath" do
    it "returns a default value" do
      hound_config = instance_double(
        "HoundConfig",
        commit: double("Commit"),
        content: {
          "test" => {},
        },
      )

      config = BuildConfig.run(hound_config, "test")

      expect(config.serialize).to eq("--- {}\n")
    end
  end

  context "when the config is on the repo" do
    it "returns a config fetched from the repo" do
      allow(ConfigClassFromName).to receive(:run).and_return(Config::Test)
      commit = stubbed_commit(".test.yaml" => <<~CON)
        key: value
      CON
      hound_config = double(
        "HoundConfig",
        commit: commit,
        content: { "test" => { "config_file" => ".test.yaml" } },
      )

      config = BuildConfig.run(hound_config, "test")

      expect(config.serialize).to eq("---\nkey: value\n")
    end
  end

  context "when the filepath is a url" do
    context "when url exists" do
      it "returns the content of the url" do
        hound_config = double(
          "HoundConfig",
          commit: double("Commit"),
          content: {
            "test" => {
              "config_file" => "http://example.com/rubocop.yml",
            },
          },
        )
        response = <<-EOS.strip_heredoc
          LineLength:
            Max: 90
        EOS
        stub_request(:get, "http://example.com/rubocop.yml").
          to_return(status: 200, body: response)

        config = BuildConfig.run(hound_config, "test")

        expect(config.serialize).to eq "---\nLineLength:\n  Max: 90\n"
      end
    end

    context "when the url does not exist" do
      it "raises an exception" do
        hound_config = double(
          "HoundConfig",
          commit: double("Commit"),
          content: {
            "test" => {
              "config_file" => "http://example.com/rubocop.yml",
            },
          },
        )
        stub_request(
          :get,
          "http://example.com/rubocop.yml",
        ).to_return(
          status: 404,
          body: "Could not find resource",
        )

        expect { BuildConfig.run(hound_config, "test") }.to raise_error do |e|
          expect(e).to be_a Config::FetchError
          expect(e.message).to eq "404 Could not find resource"
        end
      end
    end
  end
end
