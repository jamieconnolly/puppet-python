require "spec_helper"

describe "python" do
  let(:facts) { default_test_facts }

  it do
    should contain_class("python::pyenv")
    should contain_file("/opt/python")
  end

  context "osfamily => Darwin" do
    it do
      should include_class("boxen::config")
      should contain_boxen__env_script("python")

      should contain_file("/opt/python").with({
        :ensure => "directory",
        :owner  => "testuser",
      })
    end
  end

  context "osfamily => Debian" do
    let(:facts) { default_test_facts.merge(:osfamily => "Debian", :id => "root") }

    it do
      should_not include_class("boxen::config")
      should_not contain_boxen__env_script("python")

      should contain_file("/opt/python").with({
        :ensure => "directory",
        :owner  => "root",
      })
    end
  end
end
