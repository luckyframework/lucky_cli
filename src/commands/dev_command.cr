class DevCommand < ACON::Command
  include LuckyTask::TextHelpers

  def configure : Nil
    name "dev"

    description "Boot the lucky development server"

    help <<-TEXT
    Boot your Lucky application. Uses the Procfile.dev to
    run each service. Edit this file to change which services
    are booted.
    TEXT
  end

  def execute(input : ACON::Input::Interface, output : ACON::Output::Interface) : ACON::Command::Status
    style = ACON::Style::Athena.new(input, output)

    unless inside_app_dir? && has_procfile?
      style.new_line
      style.puts "You are not in a Lucky project".colorize(:red)
      style.new_line
      style.puts "Try this..."
      style.new_line
      style.puts %(  #{red_arrow} Run #{"lucky init".colorize(:green)} to create a Lucky project.)
      style.puts %(  #{red_arrow} Change your project's root directory to see what tasks are available.)
      return ACON::Command::Status::FAILURE
    end

    Nox.run(procfile_path.to_s)

    ACON::Command::Status::SUCCESS
  end

  private def inside_app_dir? : Bool
    tasks_file = ENV.fetch("LUCKY_TASKS_FILE", "./tasks.cr")
    File.exists?(Path[tasks_file])
  end

  private def has_procfile? : Bool
    File.exists?(procfile_path)
  end

  private def procfile_path : Path
    Path["Procfile.dev"]
  end
end
