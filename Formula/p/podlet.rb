class Podlet < Formula
  desc "Generate podman quadlet files from a podman command or compose file"
  homepage "https://github.com/containers/podlet"
  url "https://github.com/containers/podlet/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "b91398ef75566a2a646e9845d1211854e7275fce727d4b976e7d8a3c4430ae52"
  license "MPL-2.0"
  head "https://github.com/containers/podlet.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected_output = <<~EOS
      # hello.container
      [Container]
      Image=quay.io/podman/hello
    EOS

    assert_equal expected_output, shell_output("#{bin}/podlet podman run quay.io/podman/hello")
  end
end
