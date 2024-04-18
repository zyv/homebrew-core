class Moon < Formula
  desc "Task runner and repo management tool for the web ecosystem, written in Rust"
  homepage "https://moonrepo.dev/moon"
  url "https://github.com/moonrepo/moon/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "0076091e294f8b9916f849f233472f10345b982d56901aee9d55dcfc0269f704"
  license "MIT"
  head "https://github.com/moonrepo/moon.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18d2eb9cfdf6fc1486c533b0a3f67e3507f21589f1871c3fb1a312e96e8541f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61607a9dd1e4194bc0b164ea2b4efaa43f79347f34fd63ef1156f700cf62dcad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03b80553b7bb4087d9db1d3613b9507c4103e1857d68998dfd656e318337a3ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "711338f123cc716f246319617392d25e993727d11d9f449d3ef9754feb25d797"
    sha256 cellar: :any_skip_relocation, ventura:        "4387a9dbc3b156dfa45da05725d7076977fa994c8293ba104554900a36a7b36b"
    sha256 cellar: :any_skip_relocation, monterey:       "b46a4c98664f6da7d438e437d42c361dcfb11c43f50ea1ee9c59449c3971aa56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b91347f8b3572f661b22c521860865e40cfb5fcd7a4be746080f7e7bb8d40a5c"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"moon", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, MOON_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    system bin/"moon", "init", "--minimal", "--yes"
    assert_predicate testpath/".moon"/"workspace.yml", :exist?
  end
end
