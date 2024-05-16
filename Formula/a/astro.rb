class Astro < Formula
  desc "To build and run Airflow DAGs locally and interact with the Astronomer API"
  homepage "https://www.astronomer.io/"
  url "https://github.com/astronomer/astro-cli/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "e50bda713cf89b8a1c7c1ee40b88e4b88ef834d5e62774c7bea247468a1134a0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3dfa402da14c9296e7e36ded98762e88735d24f1071908578cfecf5f3472072"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3dfa402da14c9296e7e36ded98762e88735d24f1071908578cfecf5f3472072"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3dfa402da14c9296e7e36ded98762e88735d24f1071908578cfecf5f3472072"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e3087edc3507d4a9a9c1108da6ea8cde7449668fcf29625dde1ac84166dfb35"
    sha256 cellar: :any_skip_relocation, ventura:        "7e3087edc3507d4a9a9c1108da6ea8cde7449668fcf29625dde1ac84166dfb35"
    sha256 cellar: :any_skip_relocation, monterey:       "7e3087edc3507d4a9a9c1108da6ea8cde7449668fcf29625dde1ac84166dfb35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67150a0d9b57eb3095c813ce27583d11899febeffae9fcfdb637567bdd16a070"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/astronomer/astro-cli/version.CurrVersion=#{version}")

    generate_completions_from_executable(bin/"astro", "completion")
  end

  test do
    version_output = shell_output("#{bin}/astro version")
    assert_match("Astro CLI Version: #{version}", version_output)

    run_output = shell_output("echo 'y' | #{bin}/astro dev init")
    assert_match(/^Initializing Astro project*/, run_output)
    assert_predicate testpath/".astro/config.yaml", :exist?

    run_output = shell_output("echo 'test@invalid.io' | #{bin}/astro login astronomer.io --token-login=test", 1)
    assert_match(/^Welcome to the Astro CLI*/, run_output)
  end
end
