class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://github.com/gopasspw/gopass-jsonapi/archive/refs/tags/v1.15.13.tar.gz"
  sha256 "810fe36396aae3d0e82eabf1de43de824255ab69a7528354714777268ee5d3e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e9398a531fe5ab450d68bb5a9404bf6dee9dbd6da002caff016ebb674856217"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d488f0c23c744ad49fcbc281589e18a669e74d66ad390c89a962a72033ffbd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c7e8e357ad765debc90b74747a6724d05b905653ef574cbddc1ca4328267eb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "9dbbe64ea74130b5bfd1391c4c1ecb8392a6b8b18a61674da75f84a2bc58543e"
    sha256 cellar: :any_skip_relocation, ventura:        "bc98e741ceae9e3468222ce433fa19b5f9ea4eba5f25ddae5cf933a83e26f908"
    sha256 cellar: :any_skip_relocation, monterey:       "66a32cafe5bcc58f823b096f6b959fcb04c4a7376a3f54b44b804910e3ea0655"
  end

  depends_on "go" => :build
  depends_on "gopass"

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS

    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"

      system Formula["gopass"].opt_bin/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system Formula["gopass"].opt_bin/"gopass", "generate", "Email/other@foo.bar", "15"
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end

    assert_match(/^gopass-jsonapi version #{version}$/, shell_output("#{bin}/gopass-jsonapi --version"))

    msg = '{"type": "query", "query": "foo.bar"}'
    assert_match "Email/other@foo.bar",
      pipe_output("#{bin}/gopass-jsonapi listen", "#{[msg.length].pack("L<")}#{msg}")
  end
end
