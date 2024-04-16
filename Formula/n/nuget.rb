class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v6.9.1/nuget.exe"
  sha256 "82bb13e2365e1e5ee7d0975618dcf90b279427de8a7ecb338b9b78bfc457d51b"
  license "MIT"

  livecheck do
    url "https://dist.nuget.org/tools.json"
    regex(%r{"url":\s*?"[^"]+/v?(\d+(?:\.\d+)+)/nuget\.exe",\s*?"stage":\s*?"ReleasedAndBlessed"}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e9b2794f708ebfb6ec3384dbfbb99c4819fb81d143aab3c92b49cfadd2eca3c4"
  end

  depends_on "mono"

  def install
    libexec.install "nuget.exe" => "nuget.exe"
    (bin/"nuget").write <<~EOS
      #!/bin/bash
      mono #{libexec}/nuget.exe "$@"
    EOS
  end

  test do
    assert_match "NuGet.Protocol.Core.v3", shell_output("#{bin}/nuget list packageid:NuGet.Protocol.Core.v3")
  end
end
