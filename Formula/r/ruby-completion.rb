class RubyCompletion < Formula
  desc "Bash completion for Ruby"
  homepage "https://github.com/mernen/completion-ruby"
  url "https://github.com/mernen/completion-ruby/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "70b9ae9154076b561f0d7b2b74893258dc00168ded3e8686f14e349f4a324914"
  license "MIT"
  version_scheme 1
  head "https://github.com/mernen/completion-ruby.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ddef10f9066b45d6d50d2795bfc16b7fbc528145db20e6a7c7714e2a26e3ac83"
  end

  def install
    bash_completion.install "completion-ruby" => "ruby"
  end

  test do
    assert_match "-F __ruby",
      shell_output("bash -c 'source #{bash_completion}/ruby && complete -p ruby'")
  end
end
