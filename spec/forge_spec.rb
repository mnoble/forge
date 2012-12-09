require "ostruct"
require_relative "../lib/forge"

describe Forge do
  class User < OpenStruct; end

  before do
    Forge.reset!
    Forge.define(:user, User) do |u|
      u.name = "Spike"
      u.location = "Mars"
    end
  end

  it "saves factory definitions to a registry" do
    Forge.registry[:user].should_not be_nil
  end

  it "raises an error when defining the same factory twice" do
    expect { Forge.define(:user, User) }.to raise_error(Forge::DuplicateFactoryError)
  end

  it "builds a forged object of the type specified when defining it" do
    Forge.build(:user).should be_a User
  end

  it "sets attributes on the forged objects based on the block passed during definition" do
    Forge.build(:user).name.should == "Spike"
  end

  it "allows attributes to be overwritten via build" do
    Forge.build(:user, name: "Jet").name.should == "Jet"
  end

  it "raises an error when trying to build a non-existent factory" do
    expect { Forge.build(:not_a_thing) }.to raise_error(Forge::MissingFactoryError)
  end

  it "creates factories with an attribute that is another factory to be built" do
    Forge.define(:bounty_hunter, User) do |f|
      f.name = "Spike"
      f.location = "Mars"
      f.partner = Forge.build(:user, name: "Jet")
    end

    Forge.build(:bounty_hunter).partner.name.should == "Jet"
  end

  describe "sequence" do
    it "keeps a integer sequence" do
      Forge.sequence.value.should == 1
      Forge.sequence.next.should == 2
      Forge.sequence.value.should == 2
    end

    it "is reset" do
      Forge.sequence.next
      Forge.sequence.value.should == 2
      Forge.reset!
      Forge.sequence.value.should == 1
    end
  end
end
