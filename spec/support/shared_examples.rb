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
    it "is a new file review" do
      repo = instance_double("Repo", owner: nil)
      build = instance_double(
        "Build",
        commit_sha: "somesha",
        pull_request_number: 123,
        repo: repo,
      )
      filename = lintable_files.first
      commit_file = instance_double(
        "CommitFile",
        content: "code",
        filename: filename,
        patch: "patch",
      )
      file_review = instance_double("FileReview")
      hound_config = instance_double("HoundConfig")
      missing_owner = instance_double("MissingOwner")
      allow(FileReview).to receive(:create!).and_return(file_review)
      allow(MissingOwner).to receive(:new).and_return(missing_owner)
      allow(Resque).to receive(:enqueue)
      linter = described_class.new(build: build, hound_config: hound_config)

      expect(linter.file_review(commit_file)).to eq file_review
      expect(Resque).to have_received(:enqueue)
    end
  end

  describe "#name" do
    it "is the class name converted to a config-friendly format" do
      build = instance_double("Build")
      hound_config = instance_double("HoundConfig")
      linter = described_class.new(build: build, hound_config: hound_config)

      expect(linter.name).to eq linter_name
    end
  end
end
