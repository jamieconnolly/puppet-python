require "spec_helper"

describe "python::global" do
  let(:facts) { default_test_facts }

  context "system ruby" do
    let(:params) { { :version => "system" } }

    it do
      should contain_file("/test/boxen/pyenv/version").with({
        :content => "system\n",
        :owner   => "testuser",
        :require => nil,
      })
    end
  end

  context "non-system ruby" do
    let(:params) { { :version => "2.7.8" } }

    it do
      should contain_file("/test/boxen/pyenv/version").with({
        :content => "2.7.8\n",
        :owner   => "testuser",
        :require => "Python::Version[2.7.8]",
      })
    end
  end
end
