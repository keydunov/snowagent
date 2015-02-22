require 'spec_helper'

RSpec.describe SnowAgent::VERSION do
  it "contains 3 digits" do
    expect(SnowAgent::VERSION).to match(/^\d+\.\d+\.\d+$/)
  end
end
