require 'spec_helper'

describe Isbm::Duration do
  context "when invalid arguments" do
    it "should raise an ArgumentError with invalid symbols" do
      lambda { Isbm::Duration.new(:invalid_symbol => 1) }.should raise_error
    end

    it "should raise an ArgumentError with negative values" do
      lambda { Isbm::Duration.new(:years => -1) }.should raise_error
    end
  end

  context "when valid arguments" do
    it "supports single date values" do
      Isbm::Duration.new(:years => 2).to_s.should eq "P2Y"
      Isbm::Duration.new(:months => 2).to_s.should eq "P2M"
      Isbm::Duration.new(:days => 2).to_s.should eq "P2D"
    end

    it "passes through 0 date values" do
      Isbm::Duration.new(:years => 0).to_s.should eq "P0Y"
      Isbm::Duration.new(:months => 0).to_s.should eq "P0M"
      Isbm::Duration.new(:days => 0).to_s.should eq "P0D"
    end

    it "supports multiple date values" do
      Isbm::Duration.new(:years => 1, :months => 2).to_s.should eq "P1Y2M"
      Isbm::Duration.new(:years => 1, :months => 2, :days => 3).to_s.should eq "P1Y2M3D"
    end

    it "supports single time values" do
      Isbm::Duration.new(:hours => 2).to_s.should eq "PT2H"
      Isbm::Duration.new(:minutes => 2).to_s.should eq "PT2M"
      Isbm::Duration.new(:seconds => 2).to_s.should eq "PT2S"
    end

    it "passes through 0 time values" do
      Isbm::Duration.new(:hours => 0).to_s.should eq "PT0H"
      Isbm::Duration.new(:minutes => 0).to_s.should eq "PT0M"
      Isbm::Duration.new(:seconds => 0).to_s.should eq "PT0S"
    end

    it "supports multiple time values" do
      Isbm::Duration.new(:hours => 1, :minutes => 2).to_s.should eq "PT1H2M"
      Isbm::Duration.new(:hours => 1, :minutes => 2, :seconds => 3).to_s.should eq "PT1H2M3S"
    end

    it "supports combined date and time values" do
      Isbm::Duration.new(:years => 1, :hours => 2).to_s.should eq "P1YT2H"
      Isbm::Duration.new(:months => 1, :minutes => 2).to_s.should eq "P1MT2M"
      Isbm::Duration.new(:years => 1, :months => 2, :days => 3, :hours => 4, :minutes => 5, :seconds => 6).to_s.should eq "P1Y2M3DT4H5M6S"
    end

    it "supports more values exceeding carry over points" do
      Isbm::Duration.new(:months => 13, :days => 400, :hours => 25, :minutes => 61, :seconds => 62).to_s.should eq "P13M400DT25H61M62S"
    end

    it "supports fractional values" do
      Isbm::Duration.new(:minutes => 0.5).to_s.should eq "PT0.5M"
    end
  end
end