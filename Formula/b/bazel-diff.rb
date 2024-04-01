class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/releases/download/7.0.0/bazel-diff_deploy.jar"
  sha256 "0b9e32f9c20e570846b083743fe967ae54d13e2a1f7364983e0a7792979442be"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ce8a8a1606a6d23a21e85d7f343efa06353c39c04915d672fea2b3d6ad2ef031"
  end

  depends_on "bazel" => :test
  depends_on "openjdk"

  def install
    libexec.install "bazel-diff_deploy.jar"
    bin.write_jar_script libexec/"bazel-diff_deploy.jar", "bazel-diff"
  end

  test do
    output = shell_output("#{bin}/bazel-diff generate-hashes --workspacePath=#{testpath} 2>&1", 1)
    assert_match "ERROR: The 'info' command is only supported from within a workspace", output
  end
end
