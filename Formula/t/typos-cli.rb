class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "642d96b0f21a16e1ac53ea011cdac1f3e1b722ce4bf95119bffd2357d40cb0a1"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50341967af7ff87ac4b2c0b884033c720df0dfbf95e0d663474daa096fdc3074"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c278ade32379e5bfbcb27419287a460d40888ed18ada1be97d83ac035a7fac0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c13b2caad7e64217d0b7cb21411bd9e8bfb231a09e2418092ae64026c1b6420c"
    sha256 cellar: :any_skip_relocation, sonoma:         "4056620ab800aa9dbc1b39fe53ed0bbe864b931b41064daa3660498d436568f6"
    sha256 cellar: :any_skip_relocation, ventura:        "db6af19bf5b219b9ac1322c1eeaff51720c24c7e4d868ffa96fd6e9b7008da88"
    sha256 cellar: :any_skip_relocation, monterey:       "b047e5d675427b6f2d6188d5b496012278b5af9356a0c65107aa90efbd405a5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a41040210e0ffb5935fd8639f67f113059c7d781aa3753ab488f72989b3d3db8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
