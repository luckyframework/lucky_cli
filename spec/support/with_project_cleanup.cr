module WithProjectCleanup
  private def with_project_cleanup(project_directory = "test-project", skip_db_drop = false) : Nil
    yield

    FileUtils.cd(project_directory) {
      output = IO::Memory.new
      Process.run(
        "lucky db.drop",
        output: output,
        shell: true
      )

      output.to_s.should contain("Done dropping")
    } unless skip_db_drop
  ensure
    FileUtils.rm_rf project_directory
  end
end
