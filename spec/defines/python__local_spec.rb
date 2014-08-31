require "spec_helper"

describe "python::local" do
  let(:facts) { default_test_facts }
  let(:title) { "/path/to/a/thing" }

  context "ensure => present, version => 2.7.8" do
    let(:params) { {
      :ensure  => "present",
      :version => "2.7.8"
    } }

    it do
      should contain_python__version("2.7.8")
      should contain_file("/path/to/a/thing/.python-version").with({
        :ensure => "present",
        :content => "2.7.8\n",
        :replace => true
      })
    end
  end

  context "ensure => present, version => v1.0" do
    let(:params) { {
      :ensure  => "present",
      :version => "v1.0"
    } }

    it do
      expect {
        should contain_file("/path/to/a/thing/.node-version")
      }.to raise_error(Puppet::Error, /version must be of the form X\.Y\.Z, is v1\.0/)
    end
  end

  context "ensure => absent" do
    let(:params) { {
      :ensure  => "absent"
    } }

    it do
      should contain_file("/path/to/a/thing/.python-version").with_ensure("absent")
    end
  end

  context "ensure => whatever" do
    let(:params) { {
      :ensure  => "whatever"
    } }

    it do
      expect {
        should contain_file("/path/to/a/thing/.node-version")
      }.to raise_error(Puppet::Error, /ensure must be present|absent, is whatever/)
    end
  end
end
