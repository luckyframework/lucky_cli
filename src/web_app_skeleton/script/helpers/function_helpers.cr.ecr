require "colorize"

# These are helper methods provided to help keep your code
# clean. Add new methods, or alter these as needed.

def notice(message : String) : Nil
  puts "\n▸ #{message}"
end

def print_done : Nil
  puts "✔ Done"
end

def print_error(message : String) : Nil
  puts "There is a problem with your system setup:\n".colorize.red.bold
  puts "#{message}\n".colorize.red.bold
  Process.exit(1)
end

def command_not_found(command : String) : Bool
  Process.find_executable(command).nil?
end

def command_not_running(command : String, *args) : Bool
  output = IO::Memory.new
  code = Process.run(command, args, output: output).exit_code
  code > 0
end

def run_command(command : String, *args) : Nil
  Process.run(command, args, output: STDOUT, error: STDERR, input: STDIN)
end
