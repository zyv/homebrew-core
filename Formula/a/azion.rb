class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.23.0.tar.gz"
  sha256 "e7791aafa91d3fbc98ff5f5e442c96be5bc1fc31d997179a6887c0c229af2e9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88bc14023738f06ac3daa269f7a9c2bf18cb993b937435cab34cb5f9df94f26c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b21d7bafa4addfa6e2fadfdcbb22bd5540990d395f2559f9590391c7d90f3e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84a2c3e07792da6a5919f0455b0447937e6c0f5a6d0c040f39e7d97191a62dde"
    sha256 cellar: :any_skip_relocation, sonoma:         "fcac23be28c9ae4a0f75fe02ff4605b9b06be4117da8692f8fb0fb2737665035"
    sha256 cellar: :any_skip_relocation, ventura:        "3b7e1190d2671c427b1d5b6e4a071ecdc9cf154c45d275ef3e03a53d1ae2b213"
    sha256 cellar: :any_skip_relocation, monterey:       "f2adffdf18bc5e61817ab310135b5e514e625310a97525db9efc936c6ddd5032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c2550db3073c89aab07d29104f514da5661d62de44b57e4cc8c846bc51666b2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
