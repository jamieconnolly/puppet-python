Puppet::Type.newtype(:virtualenv) do
  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    defaultto(:present)
  end

  newparam(:environment) do
    validate do |value|
      unless value.is_a? Hash
        raise Puppet::ParseError,
          "Expected environment to be a Hash, got #{value.class.name}"
      end
    end
  end

  newparam(:name) do
    isnamevar
  end

  newparam(:python) do
    validate do |value|
      unless value.is_a? String
        raise Puppet::ParseError,
          "Expected python to be a String, got #{value.class.name}"
      end
    end
  end

  newparam(:user) do
    defaultto Facter.value(:id)
  end

  autorequire :python do
    Array.new.tap do |a|
      if @parameters.include?(:python) && python_version = @parameters[:python].to_s
        a << python_version if catalog.resource(:python, python_version)
      end
    end
  end

  autorequire :user do
    Array.new.tap do |a|
      if @parameters.include?(:user) && user = @parameters[:user].to_s
        a << user if catalog.resource(:user, user)
      end
    end
  end
end
