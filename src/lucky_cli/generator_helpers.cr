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

  def create_file(text, filename)
    within_project do
    end
  end

  def append_text(text, to)
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
