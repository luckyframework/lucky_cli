class LuckyCli::Init
  def self.run : Nil
    new.run
  end

  def run : Nil
    LuckyCli::Wizard::Web.run
  end
end
