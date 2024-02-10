class Notify < Formula
  desc "Stream the output of any CLI and publish it to a variety of supported platforms"
  homepage "https://github.com/projectdiscovery/notify"
  url "https://github.com/projectdiscovery/notify/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "b9883c8476f17465c7fced603382e6d3f379014ac7fae79a4bb61525a5fc63e8"
  license "MIT"
  head "https://github.com/projectdiscovery/notify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d474d89a4dc8a38006226e552101ad8c836d1d16d6ad925f98bd3b8cc577ecc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a98b613b397408f9064059db3cb9d395d00c34f60e5b47195f2a3d3442be76f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a98b613b397408f9064059db3cb9d395d00c34f60e5b47195f2a3d3442be76f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a98b613b397408f9064059db3cb9d395d00c34f60e5b47195f2a3d3442be76f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "fac6a12c063651dc6b326407549e4ed9a572809afddd1f981379856e3a2038d3"
    sha256 cellar: :any_skip_relocation, ventura:        "4ab287f6289bd0e830b3e599c7b886d6399c95639712edf5e6e972b37cf8cdb8"
    sha256 cellar: :any_skip_relocation, monterey:       "4ab287f6289bd0e830b3e599c7b886d6399c95639712edf5e6e972b37cf8cdb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ab287f6289bd0e830b3e599c7b886d6399c95639712edf5e6e972b37cf8cdb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62de427da765f4b2b26e38f055a5adf2fdf2c01410e7c2115786618b4cc7c6ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/notify"
  end

  test do
    assert_match "Current Version: #{version}", shell_output("#{bin}/notify -disable-update-check -version 2>&1")
    output = shell_output("#{bin}/notify -disable-update-check -config \"#{testpath}/non_existent\" 2>&1", 1)
    assert_match "Could not read config", output
  end
end
