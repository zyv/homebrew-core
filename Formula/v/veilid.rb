class Veilid < Formula
  desc "Peer-to-peer network for easily sharing various kinds of data"
  homepage "https://veilid.com/"
  url "https://gitlab.com/veilid/veilid/-/archive/v0.3.1/veilid-v0.3.1.tar.gz"
  sha256 "c99a90c09785bf595aef4219f6ce7d613bc3c819b1f4c60f935764b8d580231e"
  license "MPL-2.0"
  head "https://gitlab.com/veilid/veilid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbabf7a7a25e71201c63833657ce97ad4adf56222440b9cf0e7efe229fa62a1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca7c896225086c0deaaccfdb5a5fc225d3c95cbcf443419e40f3220afa194b19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "635b9f52fd491f24789e14b153253bf4f9fd98412751f93890b4649e70741530"
    sha256 cellar: :any_skip_relocation, sonoma:         "91e95db22e2c2ead8322c63db98795c59fe036b11748e2f8ea8cf740ab2adade"
    sha256 cellar: :any_skip_relocation, ventura:        "af2f63f143f0e780aab3c1548eb79dcc3ee3a108e480e9033cdad5bcf96c091c"
    sha256 cellar: :any_skip_relocation, monterey:       "b4e4372922adf7955a03506f4b160187a9ab10261ed8dc8cf1f435103ce8cde6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6c2ae1ca0b9a5d2afd2d7cf726a954cea96ad19f03f59d1c623faedcb36523d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "veilid-cli")
    system "cargo", "install", *std_cargo_args(path: "veilid-server")
  end

  test do
    require "yaml"
    server_config = YAML.load(shell_output(bin/"veilid-server --dump-config"))
    assert_match "server.crt", server_config["core"]["network"]["tls"]["certificate_path"]
    assert_match "Invalid server address", shell_output(bin/"veilid-cli --address FOO 2>&1", 1)
  end
end
