class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "2b4723c3ab0e81a4b385e2d85ccc3f82b1046b21c2fed3c76aec1a378a5d8e25"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05f68f3caf0b4cef0870c96275a817bccfd9b903290a823c8b3b4a2e670a210a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "428409d7fbe42d5724fc854f327b60a0495a81e55dbea52e9c2e67d81806b236"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa57538c97aff157112eb556cd5488fd0d0626f53bc637753710e8b09ffef5c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4e38053926da306851e7f52dd21c94a6c7f01230acfc74bd4ddba1aa8c5129d"
    sha256 cellar: :any_skip_relocation, ventura:        "0cdca72ad1c8de934c61e079842d06d5fdfd4f345ccf08370cc5f93f78a85128"
    sha256 cellar: :any_skip_relocation, monterey:       "b240b9c21819088b04c045a82480e6d5650947e68c38f136aaada618deef2bf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56241d9e23541542bdce1c9c22905509140c3254c5b63d3ae6e8bb8ae7fedf07"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "ncurses"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"grin", "server", "config"
    assert_predicate testpath/"grin-server.toml", :exist?
  end
end
