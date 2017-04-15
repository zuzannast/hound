# frozen_string_literal: true
require "rails_helper"

describe Linter::Stylelint do
  it_behaves_like "a linter" do
    let(:config_class) { Config::Stylelint }
    let(:job_class) { StylelintReviewJob }
    let(:lintable_files) { %w(foo.scss) }
    let(:linter_name) { "stylelint" }
    let(:not_lintable_files) { %w(foo.sass) }
  end
end
