class RattlerBuild < Formula
  desc "Universal conda package builder"
  homepage "https://github.com/prefix-dev/rattler-build"
  url "https://github.com/prefix-dev/rattler-build/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "aa667046814b7c17a245604af685dd4127cfbb04b75c73dbd6915a75dad435c0"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/rattler-build.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b42d6f271d38afaba644c5115188aa1d7796b053d4b5504369bfe60f82d9f3cb"
    sha256 cellar: :any,                 arm64_ventura:  "fb04d4a63c470a43c5e25627c0c2012528fe4c72cb1e057d7e0edcca78a4ee21"
    sha256 cellar: :any,                 arm64_monterey: "5a6f23d520025d2660f918898d2dc12f7286debda7d4c2394a8f7397c4ddfa52"
    sha256 cellar: :any,                 sonoma:         "3ac38162662a2080b8d87303a5dd44e787af23c4aad133658cb73752d3ce2e56"
    sha256 cellar: :any,                 ventura:        "ed8a07f24b74c37cd089d6f320d530d6afe66966deed38e8ef06f342c69c4a5f"
    sha256 cellar: :any,                 monterey:       "c332c235d962e0a12ee39113e4d9ec42b44b9badc19f91a931641dc40169328a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8afee27474e3e8384d04a5ae65810462c5a747bfeb4887122ba3a78ef3d17935"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rattler-build", "completion", "--shell")
  end

  test do
    (testpath/"recipe"/"recipe.yaml").write <<~EOS
      package:
        name: test-package
        version: '0.1.0'

      build:
        noarch: generic
        string: buildstring
        script:
          - mkdir -p "$PREFIX/bin"
          - echo "echo Hello World!" >> "$PREFIX/bin/hello"
          - chmod +x "$PREFIX/bin/hello"

      requirements:
        run:
          - python

      tests:
        - script:
          - test -f "$PREFIX/bin/hello"
          - hello | grep "Hello World!"
    EOS
    system bin/"rattler-build", "build", "--recipe", "recipe/recipe.yaml"
    assert_predicate testpath/"output/noarch/test-package-0.1.0-buildstring.conda", :exist?

    assert_match version.to_s, shell_output(bin/"rattler-build --version")
  end
end
