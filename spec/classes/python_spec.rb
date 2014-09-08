require "spec_helper"

describe "python" do
  let(:facts) { default_test_facts }

  it do
    should contain_class("python::pyenv")
    should contain_file("/opt/python").with({
      :ensure => "directory",
      :owner  => "testuser",
    })
  end

  context "osfamily => Darwin" do
    it do
      should contain_class("boxen::config")
      should contain_boxen__env_script("python")
    end
  end

  context "osfamily => Debian" do
    let(:facts) { default_test_facts.merge(:osfamily => "Debian") }

    it do
      should_not contain_class("boxen::config")
      should_not contain_boxen__env_script("python")
    end
  end
end
