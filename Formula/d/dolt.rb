class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "d412c4a9616cf6fe5df85a2782ab5127f20d4dad35c79cc0fa765d6c2d8c88ac"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70fea540ba1f2eb93b004abd254e82f19cd696a7ec20af4ffe60f48c9a194f2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2168b10fefe718e725609f67304fc47d8833177e54d82ad974faf15c6219c4c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffd3a1cee332b67ed20e55c757b6ad8b11d9a67c4b7f21ed73aea9a0b02ddacf"
    sha256 cellar: :any_skip_relocation, sonoma:         "eccc1ef4222c57048452bf4fecd31fcda83f6144b877a4318c3fea48fe9484d8"
    sha256 cellar: :any_skip_relocation, ventura:        "80590f0014a3a4a9b984409840164724b504c7f3ef9a7b8757b76ef4e3913288"
    sha256 cellar: :any_skip_relocation, monterey:       "2d4e8a719b98938f118a439aa4fb8e70d3e935c8ce7f9be5676702fd3954a1ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9170402d6f54e567f0ccec3e067ef7fcec9926bf097e5103a3a00df08a1cd459"
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
