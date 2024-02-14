class Mcap < Formula
  desc "Serialization-agnostic container file format for pub/sub messages"
  homepage "https://mcap.dev"
  url "https://github.com/foxglove/mcap/archive/refs/tags/releases/mcap-cli/v0.0.42.tar.gz"
  sha256 "0d450a9a8202cfb36c092a5485a09e12588a2fe913a53d4d120ded3c11268fa2"
  license "MIT"
  head "https://github.com/foxglove/mcap.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releases/mcap-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42a2916214c0bab01de9e627ec35b4dda281af33f258acf7703a8b1bdeb483ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c58cfadf1d4360bce1540bab956d17fae2ea44970583d6c34da6b59fa23598d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab998d8d3919d919d33cd43d60a9bdbce8c62b6cf7d38a37e03cf1c4538d20aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1981402e89e374a52df2c1846b4bc2bfd42c369348b622cc2e2433856e5fd34"
    sha256 cellar: :any_skip_relocation, ventura:        "8aedee37ebe84e20e9c4c7ab003671bc3df933089a21cf09ff5293c941da971e"
    sha256 cellar: :any_skip_relocation, monterey:       "8f73ba7fe10e35e4bfde2017194b54255eb46b808b2cf5b03354417b35cb8153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72d83297cf952241a8050e1fedb74f514dbaf4a12887ccd92bce4cb721542a0c"
  end

  depends_on "go" => :build

  def install
    cd "go/cli/mcap" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "bin/mcap"
    end
    generate_completions_from_executable(bin/"mcap", "completion")
  end

  test do
    resource "homebrew-testdata-OneMessage" do
      url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneMessage/OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap"
      sha256 "16e841dbae8aae5cc6824a63379c838dca2e81598ae08461bdcc4e7334e11da4"
    end

    resource "homebrew-testdata-OneAttachment" do
      url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneAttachment/OneAttachment-ax-pad-st-sum.mcap"
      sha256 "f9dde0a5c9f7847e145be73ea874f9cdf048119b4f716f5847513ee2f4d70643"
    end

    resource "homebrew-testdata-OneMetadata" do
      url "https://github.com/foxglove/mcap/raw/releases/mcap-cli/v0.0.20/tests/conformance/data/OneMetadata/OneMetadata-mdx-pad-st-sum.mcap"
      sha256 "cb779e0296d288ad2290d3c1911a77266a87c0bdfee957049563169f15d6ba8e"
    end

    assert_equal "v#{version}", shell_output("#{bin}/mcap version").strip

    resource("homebrew-testdata-OneMessage").stage do
      assert_equal "2 example [Example] [1 2 3]",
      shell_output("#{bin}/mcap cat OneMessage-ch-chx-mx-pad-rch-rsh-st-sum.mcap").strip
    end
    resource("homebrew-testdata-OneAttachment").stage do
      assert_equal "\x01\x02\x03",
      shell_output("#{bin}/mcap get attachment OneAttachment-ax-pad-st-sum.mcap --name myFile")
    end
    resource("homebrew-testdata-OneMetadata").stage do
      assert_equal({ "foo" => "bar" },
      JSON.parse(shell_output("#{bin}/mcap get metadata OneMetadata-mdx-pad-st-sum.mcap --name myMetadata")))
    end
  end
end
