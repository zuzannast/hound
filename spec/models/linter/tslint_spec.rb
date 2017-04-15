require "rails_helper"

describe Linter::Tslint do
  it_behaves_like "a linter" do
    let(:config_class) { Config::Tslint }
    let(:job_class) { TslintReviewJob }
    let(:lintable_files) { %w(foo.ts) }
    let(:linter_name) { "tslint" }
    let(:not_lintable_files) { %w(foo.js.coffee) }
  end
end
