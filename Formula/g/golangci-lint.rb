class GolangciLint < Formula
  desc "Fast linters runner for Go"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.56.1",
        revision: "a25592b52a064adbebd7f54f8bfe055171eaed9d"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/golangci/golangci-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a70c908f71a2f91d585d2a01b8aad89996115dbec9a675aa29fa3785713abb7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbeb82ac79395e1001e26f7f6a77e66568e5cdafeb0e1e48f4830fe834a1db4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b490f2993030aad59efd4b1412f0b5e04d2191b7b9a1cbf88815ea83e8d3e8eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3081d9aabf686b5579bc527ed1346c44764d89f9889d108460dcf8833d62f94"
    sha256 cellar: :any_skip_relocation, ventura:        "1a4c4638c87b1809881f908f406aa32d4434833d1ae7de3e5a39ff71fef3fd3c"
    sha256 cellar: :any_skip_relocation, monterey:       "5f1f57f0dd27a6a8f15856033a2c46fbacd9e9d2b004effdb54319af6611d47e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "832b0debbaa1eb7db4252980dd9ca8e5941959aa0632b1791e835c8693e94ca5"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/golangci-lint"

    generate_completions_from_executable(bin/"golangci-lint", "completion")
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match(/golangci-lint has version #{version} built with go(.*) from/, str_version)

    str_help = shell_output("#{bin}/golangci-lint --help")
    str_default = shell_output("#{bin}/golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath/"try.go").write <<~EOS
      package try

      func add(nums ...int) (res int) {
        for _, n := range nums {
          res += n
        }
        clear(nums)
        return
      }
    EOS

    args = %w[
      --color=never
      --disable-all
      --issues-exit-code=0
      --print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func `add` is unused (unused)"
    assert_match expected_message, ok_test
  end
end
