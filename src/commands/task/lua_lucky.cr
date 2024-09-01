class LuaLucky
  @state : Luajit::LuaState

  def self.run : Nil
    Luajit.run do |state|
      new(state).perform
    end
  end

  def initialize(@state)
  end

  def perform
    setup_package_path
  end

  private def setup_package_path
    @state.execute! {{ read_file("#{__DIR__}/setup_package_path.lua") }}
  end
end
