require "language/node"

class Zrok < Formula
  desc "Geo-scale, next-generation sharing platform built on top of OpenZiti"
  homepage "https://zrok.io"
  url "https://github.com/openziti/zrok/archive/refs/tags/v0.4.30.tar.gz"
  sha256 "b952c8d5c88c282d72ef7ecd4f3a6f1541b07867cc1aa35b7ec03eeea51a3fe5"
  license "Apache-2.0"
  head "https://github.com/openziti/zrok.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55e24403175302e7f511574e3d492a8d55fbe87a68b1eaad3cf2a2a89c62351b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d33a627a710263df8a1b4ee666dc8aa770f381699be2e3f29107044cadf30e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f83ae3a242fddcbe4e4d2885609e749b06a8dccb19fad258a2b3492cea228333"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b8735b5da50ee3faeee08a16a50950e3e037ab994800a953101f6a72affbabb"
    sha256 cellar: :any_skip_relocation, ventura:        "dae1b8ffde07028bce9d9f0a05d5ed74721e58b8c9fde8b9ca9a7fcc9d44cc12"
    sha256 cellar: :any_skip_relocation, monterey:       "d3f171bad852e44f5d9a59cd8309634285fb5b555c3633694500e7107c406e2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f5ce9b18d8a3dff56d93223392ed54c46a7ce2b33dfabe328a6d8628d8d1a3d"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd buildpath/"ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end
    ldflags = ["-X github.com/openziti/zrok/build.Version=#{version}",
               "-X github.com/openziti/zrok/build.Hash=brew"]
    system "go", "build", *std_go_args(ldflags:), "github.com/openziti/zrok/cmd/zrok"
  end

  test do
    (testpath/"ctrl.yml").write <<~EOS
      v: 3
      maintenance:
        registration:
          expiration_timeout: 24h
    EOS

    version_output = shell_output("#{bin}/zrok version")
    assert_match(version.to_s, version_output)
    assert_match(/[[a-f0-9]{40}]/, version_output)

    status_output = shell_output("#{bin}/zrok controller validate #{testpath}/ctrl.yml 2>&1")
    assert_match("expiration_timeout = 24h0m0s", status_output)
  end
end
