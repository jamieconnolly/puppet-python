require "spec_helper"

describe "python::pyenv::plugin" do
  let(:test_params) { {
    :ensure => "present",
    :source => "yyuu/pyenv-update",
  } }

  let(:facts) { default_test_facts }
  let(:params) { test_params }
  let(:title) { "pyenv-update" }

  context "ensure => present" do
    it do
      should contain_class("python::pyenv")
      should contain_repository("/test/boxen/pyenv/plugins/pyenv-update").with({
        :ensure => "present",
        :source => "yyuu/pyenv-update",
        :user   => "testuser",
      })
    end
  end
end
