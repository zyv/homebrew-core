require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.3.0.tgz"
  sha256 "75815c592daa14d50d3101573594ef76bf3b5bbe840559692d1b9c666935a667"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f98d44f9e109a0d738902e69bdbb31a87e381b01fc57f6f40ce476a9fc67b969"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f98d44f9e109a0d738902e69bdbb31a87e381b01fc57f6f40ce476a9fc67b969"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f98d44f9e109a0d738902e69bdbb31a87e381b01fc57f6f40ce476a9fc67b969"
    sha256 cellar: :any_skip_relocation, sonoma:         "21e4bcddb97ac8a38cb88d5bd219b0aa4c596a5529e64c057328dbe9680ae3d5"
    sha256 cellar: :any_skip_relocation, ventura:        "21e4bcddb97ac8a38cb88d5bd219b0aa4c596a5529e64c057328dbe9680ae3d5"
    sha256 cellar: :any_skip_relocation, monterey:       "21e4bcddb97ac8a38cb88d5bd219b0aa4c596a5529e64c057328dbe9680ae3d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f728df3330ee1077df6e2eef703044343c4818add48354deaa81179395e49ea"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
