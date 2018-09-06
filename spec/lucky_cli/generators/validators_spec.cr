require "../../spec_helper"

private def validate(string)
  LuckyCli::Generators::Validators::ProjectName.valid? string
end

private def sanitize(string)
  LuckyCli::Generators::Validators::ProjectName.sanitize string
end

describe LuckyCli::Generators::Validators::ProjectName do
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
