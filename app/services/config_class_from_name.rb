class ConfigClassFromName
  pattr_initialize :name

  def self.run(*args)
    new(*args).run
  end

  def run
    "Config::#{name.classify}".constantize
  rescue
    Config::Unsupported
  end
end
