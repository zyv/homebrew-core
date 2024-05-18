class River < Formula
  desc "Reverse proxy application, based on the pingora library from Cloudflare"
  homepage "https://github.com/memorysafety/river"
  url "https://github.com/memorysafety/river/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "32201e9b1e7f8072a4f96ccfb0ce06006115700b1b495477e4519afcda4c1bd3"
  license "Apache-2.0"
  head "https://github.com/memorysafety/river.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "source/river")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    (testpath/"example-config.toml").write <<~EOS
      [system]
        [[basic-proxy]]
        name = "Example Config"
        [basic-proxy.connector]
        proxy_addr = "127.0.0.1:80"
    EOS
    system bin/"river", "--validate-configs", "--config-toml", testpath/"example-config.toml"

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"river", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
