require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.7.4.tgz"
  sha256 "7478c7eee931842d9192e039b4e77e23741a44577e868be7de08eaaf05f17f86"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9daa4aa731d01b398e46ac58f1f8d1482a5a8a697ec4e1eb5c057d0f929d4bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9daa4aa731d01b398e46ac58f1f8d1482a5a8a697ec4e1eb5c057d0f929d4bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9daa4aa731d01b398e46ac58f1f8d1482a5a8a697ec4e1eb5c057d0f929d4bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "494f941938ad4505e1ee85fcd9ef818196fd31863457d3d688bb571903698c41"
    sha256 cellar: :any_skip_relocation, ventura:        "494f941938ad4505e1ee85fcd9ef818196fd31863457d3d688bb571903698c41"
    sha256 cellar: :any_skip_relocation, monterey:       "494f941938ad4505e1ee85fcd9ef818196fd31863457d3d688bb571903698c41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5814e48d5f51cfeaee9511b178462023fc1bb2850504022c0451a00d1f47f11"
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
