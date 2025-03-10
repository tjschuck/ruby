require_relative '../../spec_helper'
require_relative 'fixtures/common'

describe "ENV.shift" do
  it "returns a pair and deletes it" do
    ENV.should_not.empty?
    orig = ENV.to_hash
    begin
      pair = ENV.shift
      ENV.has_key?(pair.first).should == false
    ensure
      ENV.replace orig
    end
    ENV.has_key?(pair.first).should == true
  end

  it "returns nil if ENV.empty?" do
    orig = ENV.to_hash
    begin
      ENV.clear
      ENV.shift.should == nil
    ensure
      ENV.replace orig
    end
  end
end

describe "ENV.shift" do
  before :each do
    @orig = ENV.to_hash
    @external = Encoding.default_external
    @internal = Encoding.default_internal

    Encoding.default_external = Encoding::BINARY
  end

  after :each do
    Encoding.default_external = @external
    Encoding.default_internal = @internal
    ENV.replace @orig
  end

  it "uses the locale encoding if Encoding.default_internal is nil" do
    Encoding.default_internal = nil

    pair = ENV.shift
    pair.first.encoding.should equal(ENVSpecs.encoding)
    pair.last.encoding.should equal(ENVSpecs.encoding)
  end

  it "transcodes from the locale encoding to Encoding.default_internal if set" do
    Encoding.default_internal = Encoding::IBM437

    pair = ENV.shift
    pair.first.encode(Encoding::IBM437) rescue next
    pair.first.encoding.should equal(Encoding::IBM437)
    pair.last.encode(Encoding::IBM437) rescue next
    pair.last.encoding.should equal(Encoding::IBM437)
  end
end
