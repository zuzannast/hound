require "rails_helper"

describe Linter::Credo do
  it_behaves_like "a linter" do
    let(:config_class) { Config::Credo }
    let(:job_class) { CredoReviewJob }
    let(:lintable_files) { %w(foo.ex foo.exs) }
    let(:linter_name) { "credo" }
    let(:not_lintable_files) { %w(foo.txt) }
  end
end
