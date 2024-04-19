class RailsCompletion < Formula
  desc "Bash completion for Rails"
  homepage "https://github.com/mernen/completion-ruby"
  url "https://github.com/mernen/completion-ruby/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "70b9ae9154076b561f0d7b2b74893258dc00168ded3e8686f14e349f4a324914"
  license "MIT"
  version_scheme 1
  head "https://github.com/mernen/completion-ruby.git", branch: "main"

  livecheck do
    formula "ruby-completion"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a2222449142bac98c98a0c6cc546589de26126b3e2a72776a88f7e2554569e0d"
  end

  def install
    bash_completion.install "completion-rails" => "rails"
  end

  test do
    assert_match "-F __rails",
      shell_output("bash -c 'source #{bash_completion}/rails && complete -p rails'")
  end
end
