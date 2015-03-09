require 'spec_helper'
require 'yaml'

describe Krackle::CLI do
  subject { engine.query("projects[1].name") }
  let(:engine) { Krackle::Engine.new(hash) }
  let(:hash) { YAML.load_file('./spec/fixtures/profile.yml') }
  it "queries YAML" do
    expect(subject.results).to eql(%w[Firehose.io Krackle Nada])
  end
end
