class Toast < Formula
  desc "Tool for running tasks in containers"
  homepage "https://github.com/stepchowfun/toast"
  url "https://github.com/stepchowfun/toast/archive/refs/tags/v0.47.6.tar.gz"
  sha256 "6cda205ec551232106a05a94b6a71d9eb90e4d3bf1541e629062c65257aa3e6a"
  license "MIT"
  head "https://github.com/stepchowfun/toast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3dfb4325e6b40dfa31c2fb1fe1e9c7eceb4666ae186d1c889a8aea61d676c63a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8d800b018f49048c905d3cae5e96f992c0149ad311e288b96e22597d674af1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7bc2872c7faf3e3ebca6b3d2177108fad982bfe6c1d456d1c1a781f9a23ca3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a57e03244845a11cac173e6c9465878dada88bfea4626dad2ae9dbe8b9fa331"
    sha256 cellar: :any_skip_relocation, sonoma:         "7bc3cf0d7e76d8d08c20140c4487135112de927da8b7a1aa9b556b12921698d5"
    sha256 cellar: :any_skip_relocation, ventura:        "6291da3dccf2c18d4eaa364742b1b7aedceada7730d53488ca89f4b05adde693"
    sha256 cellar: :any_skip_relocation, monterey:       "665ec741102a606d923e5bf3f9e73b879f85d8ac67e67865db8d70f3622933c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d493fcdcd4505a877977c8d6eded18adcca25d5209e554f78359eb15853225f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01d0d98e1ae345f986620f1c5bb20540167ad09728d9f46446929bf3fe1d27ce"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"toast.yml").write <<~EOS
      image: alpine
      tasks:
        homebrew_test:
          description: brewtest
          command: echo hello
    EOS

    assert_match "homebrew_test", shell_output("#{bin}/toast --list")
  end
end
