require "rails_helper"

describe Linter::Python do
  it_behaves_like "a linter" do
    let(:config_class) { Config::Python }
    let(:job_class) { PythonReviewJob }
    let(:lintable_files) { %w(foo.py) }
    let(:linter_name) { "python" }
    let(:not_lintable_files) { %w(foo.rb) }
  end
end
