class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.29.0.tar.gz"
  sha256 "851901d481358c04bc66610402ec789087f4f70cf7d44830fd2f39dfb8d9f1c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "551e8f18cd3792997a83c06b0da1bbb3ff426d943ef9cf0454b986dc716b5b68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d50c9595569c7ca21db35ba27b8d36cba1e4567c85fe9c852fdaa7e3ee96b5e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2aaf0143b2fea1a18655ad139d4d7c2520326f6478cec089b194d9a9df32e2ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "aabe8c3e8e88dbcc2505986781e215ec478840b809f84d733ed960b21e8cd27a"
    sha256 cellar: :any_skip_relocation, ventura:        "a78c47480b242573e1e881dbdcaeb6abada0dc2ea7203ac520be2f5876a4aabc"
    sha256 cellar: :any_skip_relocation, monterey:       "3b822f657b1d5152f21dde6e25d48414bbec63545006fdb9a17338c4547525a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdaf6ec0ca1e93d36b607c371fc72e0967803748104791c3a3051105612bb3d2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
