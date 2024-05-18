class RonnNg < Formula
  desc "Build man pages from Markdown"
  homepage "https://github.com/apjanke/ronn-ng"
  url "https://github.com/apjanke/ronn-ng/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "180f18015ce01be1d10c24e13414134363d56f9efb741fda460358bb67d96684"
  license "MIT"

  # Nokogiri 1.9 requires a newer Ruby
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "ronn-ng.gemspec"
    system "gem", "install", "ronn-ng-#{version}.gem"
    bin.install libexec/"bin/ronn"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    bash_completion.install "completion/bash/ronn"
    zsh_completion.install "completion/zsh/_ronn"
    man1.install Dir["man/*.1"]
    man7.install Dir["man/*.7"]
  end

  test do
    (testpath/"test.ronn").write <<~EOS
      helloworld
      ==========

      Hello, world!
    EOS

    assert_match "Hello, world", shell_output("#{bin}/ronn --roff --pipe test.ronn")
  end
end
