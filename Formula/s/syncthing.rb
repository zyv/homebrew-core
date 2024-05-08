class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://github.com/syncthing/syncthing/archive/refs/tags/v1.27.7.tar.gz"
  sha256 "26c57b75663fb892ea19f077124a2dcf89fbc1cf55bd9e94b5e0495af41c9ff2"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59f281953cfdb2eaeac0897e2c334b81e773077d0fa1d162f600989cf557e104"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "119e061d9804bc057e361f933e647ffe2bf56be9dd206af743c6dce5d0a91256"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ea383632dbfa5904c764954d86be2f2a55c457fbcc705bac2538ad910667c4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3031721b5dfe865dc44cfb1cc417fd985aa4b364379931d0a6957f8a28340a5d"
    sha256 cellar: :any_skip_relocation, ventura:        "11304db616b9872726b5ebde7868c91ccfdee1693814d6093b63f2b769522029"
    sha256 cellar: :any_skip_relocation, monterey:       "e907a48fced62d85d0087806fca994ce45575ba800130c4ade1e8f37c2b1a738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "242906a8e7663744e08d1c176797f93816928fee2c7098fbf1e229d42ec913ed"
  end

  depends_on "go" => :build

  def install
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    system "go", "run", "build.go", "--version", build_version, "--no-upgrade", "tar"
    bin.install "syncthing"

    man1.install Dir["man/*.1"]
    man5.install Dir["man/*.5"]
    man7.install Dir["man/*.7"]
  end

  service do
    run [opt_bin/"syncthing", "-no-browser", "-no-restart"]
    keep_alive true
    log_path var/"log/syncthing.log"
    error_log_path var/"log/syncthing.log"
  end

  test do
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    assert_match "syncthing #{build_version} ", shell_output("#{bin}/syncthing --version")
    system bin/"syncthing", "-generate", "./"
  end
end
