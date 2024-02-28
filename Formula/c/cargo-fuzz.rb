class CargoFuzz < Formula
  desc "Command-line helpers for fuzzing"
  homepage "https://rust-fuzz.github.io/book/cargo-fuzz.html"
  url "https://github.com/rust-fuzz/cargo-fuzz/archive/refs/tags/0.12.0.tar.gz"
  sha256 "d7c5a4589b8b5db3d49113e733553c286ed8b50800cbdb327b71a1c1f7c648f0"
  license all_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build
  depends_on "rustup-init" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    rustup_init = Formula["rustup-init"].bin/"rustup-init"
    system rustup_init, "-y", "--profile", "minimal", "--default-toolchain", "beta", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"

    system "cargo", "init"
    system "#{bin}/cargo-fuzz", "init"
    assert_predicate testpath/"fuzz/Cargo.toml", :exist?
  end
end
