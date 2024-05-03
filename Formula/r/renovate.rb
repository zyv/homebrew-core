require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.339.0.tgz"
  sha256 "9a7ac3689a2393d5d9beb2e626fea9da2e6e1c6d7d60a36c60e39e3101b896c9"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256                               arm64_sonoma:   "bb554078d1aab741ca83e26b4c9c7339bb3b3e1a69f8c57471c3b9623a9755f6"
    sha256                               arm64_ventura:  "84a530599fb147d415866cb1dde5136ecdd78f724a48db640ebf80253c531ae3"
    sha256                               arm64_monterey: "26a19907e051cf169a06c462720047bd4009fd4b12bf7f559a7650b4f0b4cd7e"
    sha256                               sonoma:         "111a803ae10bedf5bc8937b08f7f42ba9784b2e7ed84311b216826420c8d57f7"
    sha256                               ventura:        "8ea97deb03f5112ad4c43ae5a24d1e0fa0e28e554943a1836c5ea53d04bc0151"
    sha256                               monterey:       "c574ba977dd565de8444f698e87d333e9e4b6d122a0b4481f427e7e68b2885f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0ecfc886f69a43a95873972d8ced66873e4eb75aad42e1f4aa8a3381e4ca654"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
