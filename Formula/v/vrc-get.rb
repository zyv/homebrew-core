class VrcGet < Formula
  desc "Open Source alternative of Command-line client of VRChat Package Manager"
  homepage "https://github.com/anatawa12/vrc-get"
  url "https://github.com/anatawa12/vrc-get/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "585c3efec6ff57b03ad820da5387b63af26b54b0202d4e82dbb9d977c0d0aef3"
  license "MIT"
  head "https://github.com/anatawa12/vrc-get.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "vrc-get")
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath/"data-home"
    system bin/"vrc-get", "update"
    assert_predicate testpath/"data-home/VRChatCreatorCompanion/Repos/vrc-official.json", :exist?
  end
end
