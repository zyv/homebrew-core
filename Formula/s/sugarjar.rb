class Sugarjar < Formula
  desc "Helper utility for a better Git/GitHub experience"
  homepage "https://github.com/jaymzh/sugarjar/"
  url "https://github.com/jaymzh/sugarjar/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "27dcadee28327585cf26d1285a0a4806352c3d118131d9efde3729d7956510bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5372e89ff6e0b73f450dd765c4271ec3df21ca9f177ecc4f415c919634ae6139"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5372e89ff6e0b73f450dd765c4271ec3df21ca9f177ecc4f415c919634ae6139"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5372e89ff6e0b73f450dd765c4271ec3df21ca9f177ecc4f415c919634ae6139"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fd2408f8f41f9d77269d0030ff3f94dd8ff6ff6fc5153954bd4cbab5949e207"
    sha256 cellar: :any_skip_relocation, ventura:        "1fd2408f8f41f9d77269d0030ff3f94dd8ff6ff6fc5153954bd4cbab5949e207"
    sha256 cellar: :any_skip_relocation, monterey:       "1fd2408f8f41f9d77269d0030ff3f94dd8ff6ff6fc5153954bd4cbab5949e207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5372e89ff6e0b73f450dd765c4271ec3df21ca9f177ecc4f415c919634ae6139"
  end

  depends_on "gh"
  # Requires Ruby >= 3.0
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "sugarjar.gemspec"
    system "gem", "install", "--ignore-dependencies", "sugarjar-#{version}.gem"
    bin.install libexec/"bin/sj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    bash_completion.install "extras/sugarjar_completion.bash"
  end

  test do
    output = shell_output("#{bin}/sj lint", 1)
    assert_match "sugarjar must be run from inside a git repo", output
    output = shell_output("#{bin}/sj bclean", 1)
    assert_match "sugarjar must be run from inside a git repo", output
  end
end
