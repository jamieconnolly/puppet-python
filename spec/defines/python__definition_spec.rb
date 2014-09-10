require "spec_helper"

describe "python::definition" do
  let(:facts) { default_test_facts }
  let(:title) { "2.7.8-github1" }

  let(:definition_path) do
    [
      "/test/boxen/pyenv",
      "plugins/python-build/share/python-build",
      title
    ].join("/")
  end

  it do
    should contain_class("python::pyenv")
    should contain_file(definition_path).with({
      :source  => "puppet:///modules/python/definitions/#{title}"
    })
  end

  context "with source" do
    let(:params) { {
      :source => "puppet:///modules/python/whatever_def"
    } }

    it do
      should contain_class("python::pyenv")
      should contain_file(definition_path).with({
        :source  => "puppet:///modules/python/whatever_def"
      })
    end
  end
end
