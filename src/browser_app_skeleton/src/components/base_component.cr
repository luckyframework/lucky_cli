abstract class BaseComponent
  include Lucky::HTMLBuilder

  needs view : IO::Memory
end
