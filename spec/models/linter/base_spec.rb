require "rails_helper"

module Linter
  class Test < Base
    FILE_REGEXP = /.+\.yes\z/
  end
end

class TestReviewJob
  @queue = :test
end

describe Linter::Test do
  it_behaves_like "a linter" do
    let(:config_class) { Config::Test }
    let(:job_class) { TestReviewJob }
    let(:lintable_files) { %w(foo.yes) }
    let(:linter_name) { "test" }
    let(:not_lintable_files) { %w(foo.no bar.nope) }
  end

  describe "#file_included?" do
    it "returns true" do
      linter = build_linter

      expect(linter.file_included?(double)).to eq true
    end
  end

  describe "#enabled?" do
    context "when the hound config is enabled for the given language" do
      it "returns true" do
        hound_config = instance_double("HoundConfig", linter_enabled?: true)
        linter = Linter::Test.new(hound_config: hound_config, build: double)

        expect(linter).to be_enabled
      end
    end

    context "when the hound config is disabled for the given language" do
      it "returns false" do
        hound_config = instance_double("HoundConfig", linter_enabled?: false)
        linter = Linter::Test.new(hound_config: hound_config, build: double)

        expect(linter).not_to be_enabled
      end
    end
  end
end
