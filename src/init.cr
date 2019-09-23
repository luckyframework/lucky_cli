class LuckyCli::Init
  def self.run
    new.run
  end

  def run
    LuckyCli::Wizard::Web.run
  end
end
