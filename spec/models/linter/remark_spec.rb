require "rails_helper"

describe Linter::Remark do
  it_behaves_like "a linter" do
    let(:config_class) { Config::Remark }
    let(:job_class) { RemarkReviewJob }
    let(:lintable_files) { %w(foo.md foo.markdown) }
    let(:linter_name) { "remark" }
    let(:not_lintable_files) { %w(foo.txt) }
  end
end
