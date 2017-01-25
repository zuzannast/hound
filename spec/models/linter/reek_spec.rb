require "rails_helper"

describe Linter::Reek do
  it_behaves_like "a linter" do
    let(:linter_name) { 'reek' }
    let(:lintable_files) { %w(foo.rb foo.rake) }
    let(:not_lintable_files) { %w(foo.js) }
  end
end
