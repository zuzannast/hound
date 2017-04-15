# frozen_string_literal: true

require "rails_helper"

describe Linter::SlimLint do
  it_behaves_like "a linter" do
    let(:config_class) { Config::SlimLint }
    let(:job_class) { LintersJob }
    let(:lintable_files) { %w(foo.slim) }
    let(:linter_name) { "slim_lint" }
    let(:not_lintable_files) { %w(foo.haml) }
  end
end
