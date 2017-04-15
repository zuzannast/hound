require "rails_helper"

describe Linter::Reek do
  it_behaves_like "a linter" do
    let(:config_class) { Config::Reek }
    let(:job_class) { ReekReviewJob }
    let(:lintable_files) { %w(foo.rb foo.rake) }
    let(:linter_name) { "reek" }
    let(:not_lintable_files) { %w(foo.js) }
  end

  describe "#name" do
    it "is the class name converted to a config-friendly format" do
      build = instance_double("Build")
      hound_config = instance_double("HoundConfig")
      linter = Linter::Reek.new(build: build, hound_config: hound_config)

      expect(linter.name).to eq "reek"
    end
  end
end
