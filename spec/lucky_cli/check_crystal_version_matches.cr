class LuckyCli::CheckCrystalVersionMatches
  def run!
    check_version_files_are_in_agreement!
    check_for_version_manager!
    check_correct_version_installed!
  end
end
