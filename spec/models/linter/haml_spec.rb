require "rails_helper"

describe Linter::Haml do
  it_behaves_like "a linter" do
    let(:config_class) { Config::Haml }
    let(:job_class) { HamlReviewJob }
    let(:lintable_files) { %w(foo.haml) }
    let(:linter_name) { "haml" }
    let(:not_lintable_files) { %w(foo.rb) }
  end
end
