# `brew install luckyframework/lucky_cli/lucky`
class Lucky < Formula
  desc "A Crystal command-line tool for generating new Lucky Web Applications"
  homepage "https://github.com/luckyframework/lucky_cli"
  license "MIT"
  url "https://github.com/luckyframework/lucky_cli/archive/refs/tags/v1.2.0.zip"
  sha256 "6fad3305c5d842a2a4efe59d8f9e51ec1ebf38e4ac7633dbcc88c8b855cd5be2"
  version "1.2.0"

  depends_on "crystal" => :build
  depends_on "git" => :build

  def install
    system "shards", "build", "lucky", "--without-development", "--no-debug", "--release"
    bin.install "./bin/lucky"
  end

  def test
    assert_match "1.2.0", shell_output("#{bin}/lucky --version").split(" ")[2]
  end
end

# `scoop bucket add lucky https://github.com/luckyframework/lucky_cli`
# `scoop install lucky`
