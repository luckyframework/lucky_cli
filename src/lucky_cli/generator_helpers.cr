require "file_utils"

module LuckyCli::GeneratorHelpers
  @project_dir : String
  @template_dir : String

  getter :template_dir, :project_dir

  def copy_all_templates(from, to)
    within_project do
      FileUtils.cp_r("#{template_dir}/#{from}", "./#{to}")
    end
  end

  def copy_template(from, to)
    within_project do
      FileUtils.cp("#{template_dir}/#{from}", "./#{to}")
    end
  end

  def create_empty_dir(at path)
    within_project do
      FileUtils.mkdir_p("./#{path}")
      File.write("./#{path}/.keep", "")
    end
  end

  def create_file(path, contents)
    within_project do
      File.write("./#{path}", contents)
    end
  end

  def append_text(to, text)
    within_project do
      file = File.read(to)
      updated_file = file + text + "\n"
      File.write(to, updated_file)
    end
  end

  def run_command(command)
    within_project do
      Process.run command,
        shell: true,
        output: true,
        error: true
    end
  end

  private def within_project
    FileUtils.cd project_dir do
      yield
    end
  end
end
