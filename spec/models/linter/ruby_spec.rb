require "rails_helper"

describe Linter::Ruby do
  it_behaves_like "a linter" do
    let(:config_class) { Config::Ruby }
    let(:job_class) { RubocopReviewJob }
    let(:lintable_files) { %w(foo.rb foo.rake) }
    let(:linter_name) { "ruby" }
    let(:not_lintable_files) { %w(foo.js) }
  end
end
