require "spec"
require "file_utils"
require "json"
require "http"
require "lucky_template/spec"
require "./support/**"
require "../src/lucky_cli"

include LuckyTemplate::Spec

SPEC_UPDATE_SNAPSHOT = ENV["SPEC_UPDATE_SNAPSHOT"]? == "1"

def generate_snapshot(fixture_name, file = __FILE__, line = __LINE__, &)
  generator = yield

  actual_path = Path[Dir.current]
  expected_path = Path["#{__DIR__}/../fixtures"] / fixture_name / "expected"

  if SPEC_UPDATE_SNAPSHOT
    FileUtils.rm_rf(expected_path)
    FileUtils.mkdir_p(expected_path)
    generator.render(expected_path)
  end

  FileUtils.mkdir_p(actual_path)
  generator.render(actual_path)

  generator.template_folder.should be_valid_at(actual_path), file: file, line: line

  snapshot = LuckyTemplate.snapshot(generator.template_folder)
  snapshot.select { |_, type| type.file? }.each do |filename, _|
    actual_filename = actual_path / filename
    expected_filename = expected_path / filename

    unless File.same_content?(actual_filename, expected_filename)
      actual_lines = File.read_lines(actual_filename)
      expected_lines = File.read_lines(expected_filename)

      actual_lines.each_with_index do |actual_line, index|
        actual_line.should eq(expected_lines[index]), file: file, line: line
      end
    end
  end

  generator
end

def run_lucky(**kwargs)
  lucky_cmd = Process.find_executable("lucky")
  pending!("lucky command not found") unless lucky_cmd
  Process.run(lucky_cmd.not_nil!, **kwargs)
end

def fixtures_tasks_path
  Path["#{__DIR__}/../fixtures/tasks.cr"]
end
