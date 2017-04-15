require "rails_helper"

describe Linter::Swift do
  it_behaves_like "a linter" do
    let(:config_class) { Config::Swift }
    let(:job_class) { SwiftReviewJob }
    let(:lintable_files) { %w(foo.swift) }
    let(:linter_name) { "swift" }
    let(:not_lintable_files) { %w(foo.c) }
  end
end
