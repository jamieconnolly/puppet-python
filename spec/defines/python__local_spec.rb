require "spec_helper"

describe "python::local" do
  let(:test_params) { {
    :ensure  => "present",
    :version => "2.7.8",
  } }

  let(:facts) { default_test_facts }
  let(:params) { test_params }
  let(:title) { "/path/to/a/thing" }

  context "ensure => present, version => 2.7.8" do
    it do
      should contain_python__version("2.7.8")
      should contain_file("/path/to/a/thing/.python-version").with({
        :ensure  => "present",
        :content => "2.7.8\n",
        :replace => true,
      })
    end
  end

  context "ensure => absent" do
    let(:params) { test_params.merge(:ensure => "absent") }

    it do
      should contain_file("/path/to/a/thing/.python-version").with_ensure("absent")
    end
  end

  context "ensure => whatever" do
    let(:params) { test_params.merge(:ensure => "whatever") }

    it do
      expect {
        should contain_file("/path/to/a/thing/.python-version")
      }.to raise_error(Puppet::Error, /does not match/)
    end
  end
end
