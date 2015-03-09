require 'spec_helper'
require 'yaml'

describe Krackle::Engine do
  subject { Krackle::Engine.new(hash) }
  let(:hash) { YAML.load_file('./spec/fixtures/profile.yml') }

  context "queries" do
    it "values from a list" do
      expect(subject.query("projects[].name")).to eql(%w[Firehose.io Krackle Nada])
    end

    it "item in a list in a list" do
      expect(subject.query("projects[].contributors[].last_name")).to eql(["Goat"])
    end

    it "nth item in a list in a list" do
      expect(subject.query("projects[].contributors[0]")).to eql(["Brad Gessler", "Brad Gessler"])
    end

    it "nth item in an nth list in an nth list" do
      expect(subject.query("projects[0].contributors[0]")).to eql(["Brad Gessler"])
    end

    it "list" do
      expect(subject.query("projects[]").size).to eql(3)
    end

    it "key" do
      expect(subject.query("first_name")).to eql(["Brad"])
    end

    it "deep key" do
      expect(subject.query("location.state")).to eql(["CA"])
    end

    it "deep key list nth item" do
      expect(subject.query("location.tax_brackets[1]")).to eql(["really high"])
    end
  end
end

describe Krackle::CLI do
  it "parses cli" do
    expect(Krackle::CLI.new(["projects[].contributors[0]", "spec/fixtures/profile.yml"]).run).to eql("Brad Gessler\nBrad Gessler")
  end
end
