Puppet::Type.type(:python).provide(:pyenv) do
  desc "Install a Python version through `pyenv`."

  commands :pyenv => "pyenv"

  def self.pythonlist
    @pythonlist ||= Dir["/opt/python/*"].map do |python|
      if File.directory?(python) && File.executable?("#{python}/bin/python")
        File.basename(python)
      end
    end.compact
  end

  def self.instances
    pythonlist.map do |python|
      new({
        :name     => python,
        :version  => python,
        :ensure   => :present,
        :provider => pyenv,
      })
    end
  end

  def query
    if self.class.pythonlist.member?(version)
      { :ensure => :present, :name => version, :version => version }
    else
      { :ensure => :absent, :name => version, :version => version }
    end
  end

  def create
    command = [command(:pyenv), "install", version]
    execute(command, command_opts)
  end

  def destroy
    command = [command(:pyenv), "uninstall", "--force", version]
    execute(command, command_opts)
  end

  def cache_path
    @cache_path ||= if Facter.value(:boxen_home)
      "#{Facter.value(:boxen_home)}/cache/python"
    else
      "/tmp/python"
    end
  end

  def environment
    return @environment if defined?(@environment)

    @environment = Hash.new
    @environment["PATH"] = "#{pyenv_root}/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    @environment["PYENV_ROOT"] = pyenv_root
    @environment["PYTHON_BUILD_CACHE_PATH"] = cache_path
    @environment.merge!(@resource[:environment])
  end

  def pyenv_root
    @resource[:pyenv_root]
  end

  def version
    @resource[:version]
  end

  def command_opts
    @command_opts ||= {
      :combine            => true,
      :custom_environment => environment,
      :failonfail         => true,
      :uid                => @resource[:user],
    }
  end

end
