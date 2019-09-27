require "./text_helpers"
require "yaml"

class LuckyCli::CheckCrystalVersionMatches
  include LuckyCli::TextHelpers

  def run!
    if versions_from_config_files.any?
      check_version_files_are_in_agreement!
      # check_for_version_manager!
      # check_correct_version_installed!
    end
  end

  private def check_version_files_are_in_agreement! : Nil
    return if all_version_files_are_in_agreement?

    puts <<-TEXT
    #{"There are multiple files defining Crystal versions and they do not match.".colorize.yellow.bold}

    #{versions_from_config_files_list}

    Try this...

      #{arrow.colorize.dim} Use the same version of Crystal in all files.
      #{arrow.colorize.dim} Skip version checks: SKIP_CRYSTAL_VERSION_CHECK=1 lucky the.command


    TEXT
    exit(1)
  end

  private def versions_from_config_files_list : String
    versions_from_config_files.map do |version|
      "  #{version.defined_in} #{arrow.colorize.dim} #{version.version}"
    end.join("\n")
  end

  private def all_version_files_are_in_agreement? : Bool
    versions_from_config_files.map(&.version).uniq.size == 1
  end

  private def versions_from_config_files : Array(CrystalVersion)
    [
      version_from_crystal_version_dotfile,
      version_from_shard_yaml,
      version_from_tool_versions,
    ]
      # If some of these files don't exist or don't have a Crystal version,
      # remove them
      .compact
  end

  private def version_from_crystal_version_dotfile : CrystalVersion?
    if File.exists?(".crystal-version")
      version_string = File.read(".crystal-version").to_s.chomp
      CrystalVersion.new(version_string, defined_in: ".crystal-version")
    end
  end

  private def version_from_shard_yaml : CrystalVersion?
    if File.exists?("shard.yml")
      shard_yaml = File.read("shard.yml").to_s.chomp
      YAML.parse(shard_yaml)["crystal"]?.try do |version_string|
        CrystalVersion.new(version_string.as_s, defined_in: "shard.yml")
      end
    end
  end

  # Get version from .tool-versions (used by asdf)
  private def version_from_tool_versions : CrystalVersion?
  end

  private class CrystalVersion
    getter version, defined_in

    def initialize(@version : String, @defined_in : String)
    end
  end
end
