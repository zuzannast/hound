require "spec_helper"
require "app/services/config_class_from_name"
require "app/models/config/base"
require "app/models/config/ruby"
require "app/models/config/unsupported"

describe ConfigClassFromName do
  describe ".run" do
    context "when there is matching config class for the given name" do
      it "returns the matching config" do
        config = ConfigClassFromName.run("ruby")

        expect(config).to be(Config::Ruby)
      end
    end

    context "when there is not matching config class for the given name" do
      it "returns the unsupported config" do
        config = ConfigClassFromName.run("non-existent-config")

        expect(config).to be(Config::Unsupported)
      end
    end
  end
end
