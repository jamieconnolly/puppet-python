require "spec_helper"

describe "python::version" do
  let(:facts) { default_test_facts }
  let(:title) { "2.7.8" }

  context "ensure => present" do
    context "default params" do
      it do
        should contain_class("python")
        should contain_python("2.7.8").with({
          :ensure => "present",
          :user   => "testuser",
        })
      end
    end

    context "osfamily => Darwin" do
      it do
        should contain_class("boxen::config")
        should contain_class("homebrew::config")
        should contain_class("xquartz")
        should contain_package("readline")
      end
    end

    context "osfamily => Debian" do
      let(:facts) { default_test_facts.merge(:osfamily => "Debian") }

      it do
        should_not contain_class("boxen::config")
        should_not contain_class("homebrew::config")
        should_not contain_class("xquartz")
        should_not contain_package("readline")
      end
    end

    context "use alias" do
      let(:title) { "2.7" }

      it do
        should contain_python__alias("2.7").with({
          :ensure => "present",
          :to     => "2.7.8",
        })
      end
    end

    context "when env is default" do
      it do
        should contain_python("2.7.8").with_environment({
          "CC"         => "/usr/bin/cc",
          "FROM_HIERA" => "true",
        })
      end
    end

    context "when env is not nil" do
      let(:params) { {
        :env => { "SOME_VAR" => "flocka" }
      } }

      it do
        should contain_python("2.7.8").with_environment({
          "CC"         => "/usr/bin/cc",
          "FROM_HIERA" => "true",
          "SOME_VAR"   => "flocka",
        })
      end
    end

    context "when version needs java" do
      let(:title) { "jython-2.5.3" }

      it do
        should contain_class("java")
      end
    end
  end

  context "ensure => absent" do
    let(:params) { {
      :ensure  => "absent"
    } }

    it do
      should contain_class("python")
      should contain_python("2.7.8").with_ensure("absent")
    end
  end

  context "ensure => whatever" do
    let(:params) { {
      :ensure  => "whatever"
    } }

    it do
      expect {
        should contain_python("2.7.8")
      }.to raise_error(Puppet::Error, /does not match/)
    end
  end
end
