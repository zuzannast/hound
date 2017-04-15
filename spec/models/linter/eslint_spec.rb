require "rails_helper"

describe Linter::Eslint do
  it_behaves_like "a linter" do
    let(:config_class) { Config::Eslint }
    let(:job_class) { EslintReviewJob }
    let(:lintable_files) { %w(foo.es6 foo.js foo.jsx) }
    let(:linter_name) { "eslint" }
    let(:not_lintable_files) { %w(foo.js.coffee) }
  end

  describe "#file_included?" do
    context "file is in excluded file list" do
      it "returns false" do
        stub_eslint_config
        linter = build_linter(nil, Linter::Eslint::IGNORE_FILENAME => "foo.js")
        commit_file = double("CommitFile", filename: "foo.js")

        expect(linter.file_included?(commit_file)).to eq false
      end
    end

    context "file is not excluded" do
      it "returns true" do
        stub_eslint_config
        linter = build_linter(nil, Linter::Eslint::IGNORE_FILENAME => "foo.js")
        commit_file = double("CommitFile", filename: "bar.js")

        expect(linter.file_included?(commit_file)).to eq true
      end

      it "matches a glob pattern" do
        stub_eslint_config
        linter = build_linter(
          nil,
          Linter::Eslint::IGNORE_FILENAME => "app/javascripts/*.js\nvendor/*",
        )
        commit_file1 = double(
          "CommitFile",
          filename: "app/javascripts/bar.js",
        )
        commit_file2 = double(
          "CommitFile",
          filename: "vendor/javascripts/foo.js",
        )

        expect(linter.file_included?(commit_file1)).to be false
        expect(linter.file_included?(commit_file2)).to be false
      end
    end
  end

  def stub_eslint_config(content: {}, excluded_paths: [])
    stubbed_eslint_config = double(
      "EslintConfig",
      content: content,
      excluded_paths: excluded_paths,
      serialize: content.to_s,
    )
    allow(Config::Eslint).to receive(:new).and_return(stubbed_eslint_config)

    stubbed_eslint_config
  end

  def raw_hound_config
    <<~EOS
      eslint:
        enabled: true
        config_file: config/.eslintrc
    EOS
  end
end
