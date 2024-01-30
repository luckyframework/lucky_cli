# `brew install luckyframework/lucky_cli/lucky`
class Lucky < Formula
  desc "A Crystal command-line tool for generating new Lucky Web Applications"
  homepage "https://github.com/luckyframework/lucky_cli"
  license "MIT"
  url "https://github.com/luckyframework/lucky_cli/archive/refs/tags/v1.1.0-test2.zip"
  sha256 "a02c7d3a1d9f962d4c4b4715ce08b33b7e35cf876c95c9d6b09da73dd30574d4"
  version "1.1.0-test2"

  depends_on "crystal" => :build
  depends_on "git" => :build

  def install
    system "shards", "build", "lucky", "--without-development", "--no-debug", "--release"
    bin.install "./bin/lucky"
  end

  test do
    assert_equal "1.1.0", shell_output("#{bin}/lucky --version").strip
  end
end
