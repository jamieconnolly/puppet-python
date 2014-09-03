require "spec_helper"

describe "python::pyenv" do
  let(:facts) { default_test_facts }
  let(:params) { {
    :ensure => "v20140825",
    :prefix => "/test/boxen/pyenv",
    :user   => "testuser",
  } }

  it do
    should contain_class("python")
    should contain_repository("/test/boxen/pyenv").with({
      :ensure => "v20140825",
      :user   => "testuser",
    })
    should contain_file("/test/boxen/pyenv/versions").with_ensure("symlink")
  end
end
