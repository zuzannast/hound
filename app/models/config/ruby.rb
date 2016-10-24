module Config
  class Ruby < Base
    def initialize(hound_config, owner: nil)
      @hound_config = hound_config
      @owner = owner
    end

    def serialize(data = content)
      Serializer.yaml(data)
    end

    private

    attr_reader :hound_config

    def content
      if legacy?
        hound_config.content
      else
        parse_inherit_from(super)
      end
    end

    def parse(file_content)
      Parser.yaml(file_content)
    end

    def owner_config_content
      if @owner.present?
        Config::Ruby.new(owner_hound_config).content
      else
        {}
      end
    end

    def owner_hound_config
      BuildOwnerHoundConfig.run(@owner)
    end

  end
end
