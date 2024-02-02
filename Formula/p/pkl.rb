class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.25.2.tar.gz"
  sha256 "810f6018562ec9b54a43ba3cea472a6d6242e15da15b73a94011e1f8abc34927"
  license "Apache-2.0"

  depends_on "openjdk" => :build

  uses_from_macos "zlib"

  # To build for macOS/arm64, Pkl relies on a patch that bumps the version of GraalVM.
  # This is not a bug; this is how Pkl is actually built.
  # https://github.com/apple/pkl/blob/277f1e0cdb51deb9fc8af25563eec734bcdf01ba/.circleci/jobs/BuildNativeJob.pkl#L119-L126
  on_macos do
    on_arm do
      patch do
        # Update me during version bump.
        url "https://raw.githubusercontent.com/apple/pkl/c1a9e9e12ff290a1e765ad03db2ec6072f292301/patches/graalVm23.patch"
        sha256 "fbec8d5759b0629c53cad7440dcadb78bdba56f68c36b55cdb9fae14185eeeb6"
      end
    end
  end

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    # Need to set this so that native-image passes through env vars when calling out to the C toolchain.
    # This is only needed for GraalVM 23.0, which is only used when building for macOS/aarch64.
    ENV["NATIVE_IMAGE_DEPRECATED_BUILDER_SANITATION"] = "true" if OS.mac? && Hardware::CPU.arm?
    arch = Hardware::CPU.arm? ? "aarch64" : "amd64"
    job_name = "#{OS.mac? ? "mac" : "linux"}Executable#{arch.capitalize}"
    system "./gradlew", "--info", "--stacktrace", "-DreleaseBuild=true", job_name
    bin.install "pkl-cli/build/executable/pkl-#{OS.mac? ? "macos" : "linux"}-#{arch}" => "pkl"
  end

  test do
    assert_equal "1", pipe_output("#{bin}/pkl eval -x bar -", "bar = 1")
  end
end
