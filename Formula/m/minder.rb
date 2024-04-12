class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://github.com/stacklok/minder/archive/refs/tags/v0.0.46.tar.gz"
  sha256 "3c724f842ab08c71902d85bd2a68c89c2e99862a2e9438e5db73193b709d02b2"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb165a7b4c9d4b7839598a9ee64a77f24e128ec0660f75b90b5eb6830694e653"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e24539960bdf975c52c092f745bb0ebf8e585f2685518d994741e0e2d2257ffb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03a61b9aaca9a275a651c27b1191021d75f809a27048947d0b0895654cef7722"
    sha256 cellar: :any_skip_relocation, sonoma:         "b008b6267ffec55d86e2d5e1b5016b90518da909ed2b58ff85ae31a744d872e5"
    sha256 cellar: :any_skip_relocation, ventura:        "e03c9535b42ebb223348b2fd60ce1073079459b79e427aadcb58bac5910c623b"
    sha256 cellar: :any_skip_relocation, monterey:       "0597e807b41134524bd11cb1c53d2001b799249a77aa78a09b8597a68b45744e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6cf9f5dbc7c63c7ccc80dec9aea876caa00aef1bc42d0cc8920ade2f9535430"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
