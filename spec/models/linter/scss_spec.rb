require "rails_helper"

describe Linter::Scss do
  it_behaves_like "a linter" do
    let(:config_class) { Config::Scss }
    let(:job_class) { ScssReviewJob }
    let(:lintable_files) { %w(foo.scss) }
    let(:linter_name) { "scss" }
    let(:not_lintable_files) { %w(foo.css) }
  end
end
