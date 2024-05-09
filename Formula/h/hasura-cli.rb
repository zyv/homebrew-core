require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.39.0.tar.gz"
  sha256 "0f1b90515def6ac83390fdfcb0c82b94c20fdcf9cda061c6ab882a2000aee12f"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ae93c5fc0bea2d61ce697c4eb17bdeebec12686c94ab233fcbd3f5136c89014"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "046cf8198153df1d650613fa7cdf9b8b87f28e22636b82aceb014e77b3a25883"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9a5ab3d8e5c12f1572457e08ccfcd18a7380a5a1440e0799f35528554e20bad"
    sha256 cellar: :any_skip_relocation, sonoma:         "064374eb8a6066f93ceefce48e105295e1a792d1982bb701f3c3017c36bdfb64"
    sha256 cellar: :any_skip_relocation, ventura:        "d89d32810b3eb4da40f8e84b03d2c7f0e1cf4b4414986ee545375138d322392a"
    sha256 cellar: :any_skip_relocation, monterey:       "9de0c993b6e6960412625112ae37cb277e8fb279a39e3363cea565790c79d200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2ee515b57eb494a8016fa671dba75d75ed339111f013166f16adc48f34ba5cb"
  end

  depends_on "go" => :build
  depends_on "node@18" => :build

  def install
    Language::Node.setup_npm_environment

    ldflags = %W[
      -s -w
      -X github.com/hasura/graphql-engine/cli/v2/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/v2/plugins.IndexBranchRef=master
    ]

    # Based on `make build-cli-ext`, but only build a single host-specific binary
    cd "cli-ext" do
      # TODO: Remove `npm update pkg` when https://github.com/hasura/graphql-engine/issues/9440 is resolved.
      system "npm", "update", "pkg"
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "prebuild"
      system "./node_modules/.bin/pkg", "./build/command.js", "--output", "./bin/cli-ext-hasura", "-t", "host"
    end

    cd "cli" do
      arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
      os = OS.kernel_name.downcase

      cp "../cli-ext/bin/cli-ext-hasura", "./internal/cliext/static-bin/#{os}/#{arch}/cli-ext"
      system "go", "build", *std_go_args(output: bin/"hasura", ldflags:), "./cmd/hasura/"

      generate_completions_from_executable(bin/"hasura", "completion", base_name: "hasura", shells: [:bash, :zsh])
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
