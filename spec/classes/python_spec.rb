require "spec_helper"

describe "python" do
  let(:facts) { default_test_facts }
  let(:params) { {
    :ensure     => "present",
    :installdir => "/test/boxen/pyenv",
  } }

  it do
    should contain_repository('/test/boxen/pyenv').with({
      :ensure => "present",
      :user   => "testuser"
    })
    should contain_file('/test/boxen/pyenv/versions').with_ensure("symlink")
    should contain_file("/opt/python").with({
      :ensure => "directory",
      :owner  => "testuser",
    })
  end

  context "osfamily => Darwin" do
    it do
      should include_class("boxen::config")
      should contain_boxen__env_script("python")
    end
  end

  context "osfamily => Debian" do
    let(:facts) { default_test_facts.merge(:osfamily => "Debian") }

    it do
      should_not include_class("boxen::config")
      should_not contain_boxen__env_script("python")
    end
  end

end
