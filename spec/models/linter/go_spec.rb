require "rails_helper"

describe Linter::Go do
  it_behaves_like "a linter" do
    let(:config_class) { Config::Go }
    let(:job_class) { GoReviewJob }
    let(:lintable_files) { %w(foo.go) }
    let(:linter_name) { "go" }
    let(:not_lintable_files) { %w(foo.rb) }
  end

  describe "#file_included?" do
    context "when file is in Godeps/_workspace" do
      it "returns false" do
        commit_file = build_commit_file(filename: "Godeps/_workspace/foo/a.go")
        linter = build_linter

        expect(linter.file_included?(commit_file)).to eq false
      end
    end

    context "when file is rooted in a vendor/ directory" do
      it "returns false" do
        commit_file = build_commit_file(filename: "vendor/foo/a.go")
        linter = build_linter

        expect(linter.file_included?(commit_file)).to eq false
      end
    end

    context "when file is in a vendor/ directory" do
      it "returns false" do
        commit_file = build_commit_file(filename: "foo/vendor/bar/a.go")
        linter = build_linter

        expect(linter.file_included?(commit_file)).to eq false
      end
    end

    context "when file is not vendored" do
      it "returns true" do
        commit_file = build_commit_file(filename: "a.go")
        linter = build_linter

        expect(linter.file_included?(commit_file)).to eq true
      end
    end
  end
end
