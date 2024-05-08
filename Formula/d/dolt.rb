class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.36.1.tar.gz"
  sha256 "8f242ba393a393508665045900f15dae6c61c1dac2365d574ae41ce48ae98726"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46208fd6398db069ee27b7a35793030a1e3e60f82b2c95693591d8d6ffcbc54a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c44e60e66cc8726092bb55825488b71f3d67267a98283c425a0f0d6e8106af10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2222dfbe45018afb85a461d165e161eb510b9017485a2f2d06c4fa987e37a6a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "84c6a9c68f6cf38b97bfc1e3346c8c183105de8a155a163298f6b3fa8f233997"
    sha256 cellar: :any_skip_relocation, ventura:        "3ad30b6f088a003fbcfc38adf502e145b5bf705d55da91bcdbb483f75b49e6f4"
    sha256 cellar: :any_skip_relocation, monterey:       "f1a32dbe4bc94be75423cbef37a6a3209a0304e5f1150014d4869913551e31f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9312dfd622e570520477f414ed4b7205af1c97a50185f72af0e0e71e5e651809"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
