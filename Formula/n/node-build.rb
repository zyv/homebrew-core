class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.0.3.tar.gz"
  sha256 "4b2640880e87987359a2e42781d68eb2b9e460707d8b3419e673656b007d40bd"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fd1fed79297a546efe2c26d6809ade545c80dd8a9428b5c3836ff40d6382c92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fd1fed79297a546efe2c26d6809ade545c80dd8a9428b5c3836ff40d6382c92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fd1fed79297a546efe2c26d6809ade545c80dd8a9428b5c3836ff40d6382c92"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fd1fed79297a546efe2c26d6809ade545c80dd8a9428b5c3836ff40d6382c92"
    sha256 cellar: :any_skip_relocation, ventura:        "4fd1fed79297a546efe2c26d6809ade545c80dd8a9428b5c3836ff40d6382c92"
    sha256 cellar: :any_skip_relocation, monterey:       "4fd1fed79297a546efe2c26d6809ade545c80dd8a9428b5c3836ff40d6382c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed90f84dec1ad6f3c3b4cb7e2f1a638a6900ee29f84f1f95c15a8d7149cc71ee"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkg-config"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/node-build", "--definitions"
  end
end
