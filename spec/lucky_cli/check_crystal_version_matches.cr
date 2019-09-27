class LuckyCli::CheckCrystalVersionMatches
  def run!
    if versions_from_config_files.any?
      check_version_files_are_in_agreement!
      check_for_version_manager!
      check_correct_version_installed!
    end
  end

  private def check_version_files_are_in_agreement! : Nil
    return if all_version_files_are_in_agreement?

    puts <<-TEXT
    There are multiple files defining Crystal versions and they do not match.

    #{foo}

    Make sure those files all have the same version of Crystal.

    TEXT
    exit(1)
  end

  private def versions_from_config_files_list : String
    String.build do |string|
      versions_from_config_files.each do |version|
        string << "  ● #{version.defined_in} - #{version.verion}"
      end
    end
  end

  private def all_version_files_are_in_agreement? : Bool
    versions_from_config_files.uniq.size == versions_from_config_files.size
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
  end

  # Get version from .tool-versions (used by asdf)
  private def version_from_tool_versions : CrystalVersion?
  end

  private class CrystalVersion
    private getter version, defined_in

    def initialize(@version : String, @defined_in : String)
    end

    def_equals version
  end
end
