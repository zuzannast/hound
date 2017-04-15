RSpec.shared_examples "a linter" do
  describe ".can_lint?" do
    it "rejects files based on FILE_REGEXP" do
      not_lintable_files.each do |file|
        no_lint = described_class.can_lint?(file)

        expect(no_lint).to eq false
      end
    end

    it "accepts files based on FILE_REGEXP" do
      lintable_files.each do |file|
        yes_lint = described_class.can_lint?(file)

        expect(yes_lint).to eq true
      end
    end
  end

  describe "#file_review" do
    it "returns a saved and incomplete file review" do
      linter = build_linter
      commit_file = build_commit_file(filename: lintable_files.first)

      result = linter.file_review(commit_file)

      expect(result).to be_persisted
      expect(result).not_to be_completed
    end

    it "schedules a review job" do
      build = build(:build, commit_sha: "foo", pull_request_number: 123)
      stub_config(content: {})
      commit_file = build_commit_file(filename: lintable_files.first)
      allow(Resque).to receive(:enqueue)
      linter = build_linter(build)

      linter.file_review(commit_file)

      expect(Resque).to have_received(:enqueue).with(
        job_class,
        filename: commit_file.filename,
        commit_sha: build.commit_sha,
        linter_name: linter_name,
        pull_request_number: build.pull_request_number,
        patch: commit_file.patch,
        content: commit_file.content,
        config: "{}",
      )
    end
  end

  def stub_config(content: {})
    stubbed_config = double(
      config_class.name,
      content: content,
      serialize: content.to_s,
    )
    allow(config_class).to receive(:new).and_return(stubbed_config)

    stubbed_config
  end
end
