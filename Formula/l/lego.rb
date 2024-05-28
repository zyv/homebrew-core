class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.17.1.tar.gz"
  sha256 "339291ebf4c642f65ee00e39e58fff288a1e8c1efeafae692a7095e6ed552568"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1b366fd0b6c02b1101184339e198b8e0dcabafee8173caab3ad6cc922a9d27e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d44187058ab999e124bad40577678955d09322dd0bb531e574e35059bd9af0cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb09d0fde57532a640e963393fd57e6b5ccf71c15294f32491010121c7b9f224"
    sha256 cellar: :any_skip_relocation, sonoma:         "b972cc017bcd15d47a3a945146eff2ed526b346a24489bc3d6d69a534a961fbc"
    sha256 cellar: :any_skip_relocation, ventura:        "e766f6481ec9a76a2aec516c9a4eafc1cb801df81da9e49d7ec86b462bd7bbfa"
    sha256 cellar: :any_skip_relocation, monterey:       "e1a35b0fe4ff56c7e9fc112d639c42a8bb2030297d6dc2dae12e335de43c5d55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fad65da8e24b6a48d9dced7a15ec7d5f8542320bd890f1cbf7a78d71e15367c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("#{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1
    )
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
