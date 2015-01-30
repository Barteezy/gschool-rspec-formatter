require 'spec_helper'

describe "Somethin with words" do

  it "passes this one" do
    expect(true).to eq(true)
  end

  it "fails this one" do
    expect(true).to eq(false)
  end

  xit "is pending" do
    expect(true).to eq(true)
  end

end
