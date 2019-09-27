require "../spec_helper"

private def validate(string)
  LuckyCli::ProjectName.new(string).valid?
end

private def sanitize(string)
  LuckyCli::ProjectName.new(string).sanitized_name
end

describe LuckyCli::ProjectName do
  describe "valid?" do
    hyphenate = "sector-seven"
    special_characters = "this string is emphatic"
    title = "From the Earth to the Moon"

    it "doesn't allow special characters" do
      validate(special_characters).should be_false
    end

    it "corrects special characters" do
      expected = "this_string_is_emphatic"
      sanitize(special_characters).should eq expected
    end

    it "allows hyphens" do
      validate(hyphenate).should be_true
    end

    it "doesn't allow uppercase characters" do
      validate(title).should be_false
    end

    it "corrects uppercase characters" do
      expected = "from_the_earth_to_the_moon"
      sanitize(title).should eq expected
    end
  end
end
