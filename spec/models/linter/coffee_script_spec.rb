require "rails_helper"

describe Linter::CoffeeScript do
  it_behaves_like "a linter" do
    let(:config_class) { Config::CoffeeScript }
    let(:job_class) { CoffeelintReviewJob }
    let(:lintable_files) { %w(foo.coffee foo.coffee.erb foo.coffee.js) }
    let(:linter_name) { "coffee_script" }
    let(:not_lintable_files) { %w(foo.js) }
  end
end
