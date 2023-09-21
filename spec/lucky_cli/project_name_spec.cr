require "../spec_helper"

describe LuckyCli::ProjectName do
  describe "#valid?" do
    hyphenate = "sector-seven"
    special_characters = "this string is emphatic"
    title = "From the Earth to the Moon"

    it "doesn't allow special characters" do
      LuckyCli::ProjectName.new(special_characters).valid?.should be_false
    end

    it "corrects special characters" do
      expected = "this_string_is_emphatic"
      LuckyCli::ProjectName.new(special_characters).sanitized_name.should eq(expected)
    end

    it "allows hyphens" do
      LuckyCli::ProjectName.new(hyphenate).valid?.should be_true
    end

    it "doesn't allow uppercase characters" do
      LuckyCli::ProjectName.new(title).valid?.should be_false
    end

    it "corrects uppercase characters" do
      expected = "from_the_earth_to_the_moon"
      LuckyCli::ProjectName.new(title).sanitized_name.should eq(expected)
    end
  end
end
