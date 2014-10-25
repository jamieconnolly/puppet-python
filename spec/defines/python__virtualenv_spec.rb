require "spec_helper"

describe "python::virtualenv" do
  let(:test_params) { {
    :ensure => "present",
    :dir    => "/test/path",
    :python => "2.7.8",
    :user   => "testuser",
  } }

  let(:facts) { default_test_facts }
  let(:params) { test_params }
  let(:title) { "venv" }

  context "ensure => present" do
    it do
      should contain_class("python::pyenv")
      should contain_python__version("2.7.8")
      should contain_virtualenv("venv").with({
        :ensure        => "present",
        :environment   => {
          "PYENV_ROOT" => "/test/boxen/pyenv",
        },
        :python        => "2.7.8",
        :user          => "testuser",
      })
      should contain_file("/test/path/.python-version").with({
        :ensure  => "present",
        :content => "venv\n",
      }).that_requires("Virtualenv[venv]")
    end
  end

  context "ensure => absent" do
    let(:params) { test_params.merge(:ensure => "absent") }

    it do
      should contain_class("python::pyenv")
      should_not contain_python__version("2.7.8")
      should contain_virtualenv("venv").with({
        :ensure        => "absent",
        :environment   => {
          "PYENV_ROOT" => "/test/boxen/pyenv",
        },
        :python        => "2.7.8",
        :user          => "testuser",
      })
      should contain_file("/test/path/.python-version").with_ensure("absent")
    end
  end

  context "ensure => whatever" do
    let(:params) { test_params.merge(:ensure => "whatever") }

    it do
      expect {
        should contain_virtualenv("venv")
      }.to raise_error(Puppet::Error, /does not match/)
    end
  end
end
