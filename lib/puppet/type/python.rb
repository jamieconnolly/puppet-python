Puppet::Type.newtype(:python) do
  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    defaultto(:present)

    def insync?(is)
      @should.each { |should|
        case should
        when :present
          return true unless is == :absent
        when :absent
          return true if is == :absent
        when *Array(is)
          return true
        end
      }
      false
    end

    def retrieve
      provider.query[:ensure]
    end
  end

  newparam(:environment) do
    validate do |value|
      unless value.is_a? Hash
        raise Puppet::ParseError,
          "Expected environment to be a Hash, got #{value.class.name}"
      end
    end
  end

  newparam(:user) do
    defaultto Facter.value(:id)
  end

  newparam(:version) do
    isnamevar

    validate do |value|
      unless value.is_a? String
        raise Puppet::ParseError,
          "Expected version to be a String, got #{value.class.name}"
      end
    end
  end

  autorequire :file do
    %w(/opt/python)
  end

  autorequire :user do
    Array.new.tap do |a|
      if @parameters.include?(:user) && user = @parameters[:user].to_s
        a << user if catalog.resource(:user, user)
      end
    end
  end
end
