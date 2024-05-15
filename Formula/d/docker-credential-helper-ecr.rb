class DockerCredentialHelperEcr < Formula
  desc "Docker Credential Helper for Amazon ECR"
  homepage "https://github.com/awslabs/amazon-ecr-credential-helper"
  url "https://github.com/awslabs/amazon-ecr-credential-helper/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "7014f4c972ef360b7204d376bbd771aeebb8f1e9281948688de1bcebb0d0b0a4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "198f0cbf8a99c3c42c2121389ff64c1192fbb08ccdb4adfd52dfc46ada0b79bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ea097da1828cff0652a2004c52785da654c81ac65722eb52108a129bce51a67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ea097da1828cff0652a2004c52785da654c81ac65722eb52108a129bce51a67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ea097da1828cff0652a2004c52785da654c81ac65722eb52108a129bce51a67"
    sha256 cellar: :any_skip_relocation, sonoma:         "e36449ed1477be7ca826f754693e55ec312b80f811744af6493a6187563c6ec6"
    sha256 cellar: :any_skip_relocation, ventura:        "6e3203cb66dd05a916e756bc0e58e41f70124b57ed6878fd9537ae17f199ca7b"
    sha256 cellar: :any_skip_relocation, monterey:       "6e3203cb66dd05a916e756bc0e58e41f70124b57ed6878fd9537ae17f199ca7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e3203cb66dd05a916e756bc0e58e41f70124b57ed6878fd9537ae17f199ca7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1ac67bd6087eba7840fc12e21e48644dd7f51862398eb7d070f4e5101bfe095"
  end

  depends_on "go" => :build

  def install
    (buildpath/"GITCOMMIT_SHA").write tap.user
    system "make", "build"
    bin.install "bin/local/docker-credential-ecr-login"
  end

  test do
    output = shell_output("#{bin}/docker-credential-ecr-login", 1)
    assert_match(/^Usage: .*docker-credential-ecr-login/, output)
  end
end
