require "spec_helper"

describe "python::alias" do
  let(:test_params) { {
    :ensure => "present",
    :to => "2.7.8",
  } }

  let(:facts) { default_test_facts }
  let(:params) { test_params }
  let(:title) { "2.7" }

  context "ensure => present" do
    it do
      should contain_python("2.7.8")
      should contain_file("/opt/python/2.7").with({
        :ensure => "symlink",
        :force  => true,
        :target => "/opt/python/2.7.8",
      }).that_requires("Python::Version[2.7.8]")
    end
  end

  context "ensure => absent" do
    let(:params) { test_params.merge(:ensure => "absent") }

    it do
      should_not contain_python("2.7.8")
      should contain_file("/opt/python/2.7").with_ensure("absent")
    end
  end
end
