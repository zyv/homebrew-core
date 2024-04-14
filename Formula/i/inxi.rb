class Inxi < Formula
  desc "Full featured CLI system information tool"
  homepage "https://smxi.org/docs/inxi.htm"
  url "https://codeberg.org/smxi/inxi/archive/3.3.34-1.tar.gz"
  sha256 "7cfc5c0abe10cb59f281733ce1d526583312344007756e7713fd5c51200b80fb"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/smxi/inxi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af526f73ed5bc73c84f2eeae28c8c57fc3645ce301ca5f28ce122aeb348a4c0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af526f73ed5bc73c84f2eeae28c8c57fc3645ce301ca5f28ce122aeb348a4c0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af526f73ed5bc73c84f2eeae28c8c57fc3645ce301ca5f28ce122aeb348a4c0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2f86cc64b594983b3b9008b4e01038120e637f84de477cca324ff9f1e0ff87c"
    sha256 cellar: :any_skip_relocation, ventura:        "e2f86cc64b594983b3b9008b4e01038120e637f84de477cca324ff9f1e0ff87c"
    sha256 cellar: :any_skip_relocation, monterey:       "e2f86cc64b594983b3b9008b4e01038120e637f84de477cca324ff9f1e0ff87c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af526f73ed5bc73c84f2eeae28c8c57fc3645ce301ca5f28ce122aeb348a4c0b"
  end

  uses_from_macos "perl"

  def install
    bin.install "inxi"
    man1.install "inxi.1"

    ["LICENSE.txt", "README.txt", "inxi.changelog"].each do |file|
      prefix.install file
    end
  end

  test do
    inxi_output = shell_output("#{bin}/inxi")
    uname_r = shell_output("uname -r").strip
    assert_match uname_r.to_str, inxi_output.to_s
  end
end
