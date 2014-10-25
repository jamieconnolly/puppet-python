Puppet::Type.type(:virtualenv).provide(:pyenv) do
  desc "Create a Python virtual environment through the `pyenv-virtualenv` plugin."

  commands :pyenv => "pyenv"

  def create
    begin
      execute([command(:pyenv), "virtualenv", python, name], command_opts)
    rescue Puppet::ExecutionFailure => detail
      raise Puppet::Error, "Could not create virtualenv: #{detail}", detail.backtrace
    end
    true
  end

  def destroy
    begin
      execute([command(:pyenv), "uninstall", "--force", name], command_opts)
    rescue Puppet::ExecutionFailure => detail
      raise Puppet::Error, "Could not remove virtualenv: #{detail}", detail.backtrace
    end
    true
  end

  def exists?
    cmd = [command(:pyenv), "virtualenvs", "--bare"]
    execute(cmd, command_opts).lines.each do |line|
      if line =~ /#{@resource[:name]}\b/
        return true
      end
    end
    nil
  end

  private

  def environment
    return @resource[:environment]
  end

  def python
    @resource[:python]
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
