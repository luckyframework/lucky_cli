require "colorize"

class LuckyCli::Spinner
  DELETE_LINE = "\33[2K\r"

  private property frame_index : Int32 = 0
  private property? started : Bool = false
  private property last_frame_rendered_at : Time? = nil

  @done_text : String | ColoredString | Nil
  @start_text : String | ColoredString
  getter colorize_frame : Proc(String, ColoredString)
  getter io : IO
  delegate frames, to: self.class
  class_getter frames = [
    "⣾",
    "⣽",
    "⣻",
    "⢿",
    "⡿",
    "⣟",
    "⣯",
    "⣷",
  ]

  alias ColoredString = Colorize::Object(String)

  def initialize(
    @start_text,
    @io = STDERR,
    @done_text : String | ColoredString | Nil = nil,
    @colorize_frame = ->(frame : String) { frame.colorize.bold.green }
  )
  end

  def self.start(*args, **named_args)
    spinner = new(*args, **named_args).start
    yield.tap do |_last_value_from_block|
      spinner.stop
    end
  end

  def start : self
    self.started = true
    print_spinner

    spawn do
      while started?
        if ready_for_next_frame?
          increment_frame
          print_spinner
        end
        Fiber.yield
      end
    end

    self
  end

  def stop : self
    self.started = false
    delete_line
    io.print start_text
    io.print done_text
    self
  end

  private def ready_for_next_frame? : Bool
    if rendered_at = last_frame_rendered_at
      rendered_at < 100.milliseconds.ago
    else
      # Rendering first frame
      true
    end
  end

  def delete_line
    io.print DELETE_LINE
  end

  private def increment_frame : Nil
    if last_frame?
      self.frame_index = 0
    else
      self.frame_index += 1
    end
  end

  private def last_frame? : Bool
    frame_index == (frames.size - 1)
  end

  private def print_spinner : Nil
    delete_line
    io.print start_text
    io.print " #{current_frame} "
    self.last_frame_rendered_at = Time.utc
  end

  private def current_frame : String | ColoredString
    colorize_frame.call(frames[frame_index])
  end

  private def start_text : ColoredString
    text = @start_text
    if text.is_a?(ColoredString)
      text
    else
      # Default start text color to bold
      text.colorize.bold
    end
  end

  private def done_text : String | ColoredString
    if @done_text
      text = if @done_text.is_a?(ColoredString)
               @done_text
             else
               # Default done color to bold green
               @done_text.colorize.bold.green
             end

      " #{text}\n"
    else
      DELETE_LINE
    end
  end
end
