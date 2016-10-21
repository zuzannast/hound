class BuildConfig
  pattr_initialize :hound_config, :name

  def self.run(*args)
    new(*args).run
  end

  def run
    config_class.new(load_content)
  end

  private

  def config_class
    ConfigClassFromName.run(name)
  end

  def load_content
    if file_path
      if url?
        fetch_url
      else
        commit.file_content(file_path)
      end
    end
  end

  def fetch_url
    response = Faraday.new.get(file_path)

    if response.success?
      response.body
    else
      raise_fetch_error("#{response.status} #{response.body}")
    end
  end

  def url?
    URI::regexp(%w(http https)).match(file_path)
  end

  def file_path
    linter_config && linter_config["config_file"]
  end

  def linter_config
    hound_config.content.slice(name).values.first
  end

  def commit
    hound_config.commit
  end

  def raise_fetch_error(message)
    raise Config::FetchError.new(message)
  end
end
