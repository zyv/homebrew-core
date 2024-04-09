class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "b43fb5acda9d0c330206cd1910d621d68d1c322e75f50d9b8f2d5ceac61fcf02"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a2877c16a213e7b4628c982ced46f56f784e89f2d65ccc7b076302d0530046e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08f7eff9b1b8a957453acb7324590cf32fcc4613b7f6b003f63b3282ab0b9758"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43370e0d6a241172772d3fc4d0cffb45cebdf5b380dc8a7e8824a29d9efa92f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed77b1f5ebf163abfcc32710649233af6be522b16ba17adfc20b98205ae0bc26"
    sha256 cellar: :any_skip_relocation, ventura:        "ed83a15a956b25a78b0858663c578074f0d7ef4be19cb2727f841f357da625e0"
    sha256 cellar: :any_skip_relocation, monterey:       "89da439421bd259dc69ec0b8f8a958583e5dd2b3ef75de8133814337bbf5091e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d22c90c1bdb011fe99c47320e6c85be65aec39f87066d524730bd4a50097205"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/neosync"
    end

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
