class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.3.31.tar.gz"
  sha256 "a76dded5c65c9694fabcc667be361c6961adcc5f12f9f37f665ca2bd08820eeb"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b0a2745e600c0bbde4503f4e796d6f5b6465edbeab804bcdb413c8f32c5f414"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce92f7a6550065a63084a1bb564b5b78a0affbdfe5d10e931ecb462c369fedb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8bbe6b893b247706968a94fd25c444e484993f3f2da1a5605ea76b8a6fcf422"
    sha256 cellar: :any_skip_relocation, sonoma:         "46f05bda694796e776a7f064488d5f4c7a7e492e52de09efcf8caeb9699ec0ee"
    sha256 cellar: :any_skip_relocation, ventura:        "a63d001b78564b4b36c3400806013abaff33d62abdd823528533a2612c6f7ccf"
    sha256 cellar: :any_skip_relocation, monterey:       "ae807c876df1164b77c70bcaa520448e24f0fc86db4f2cf4472c1e036f6d1f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee99dd2f79a21ab1ee5523b945a1d5f1e78b55fd0d7418571f2f690196aa2bf8"
  end

  depends_on "go" => :build

  # patch build, upstream pr ref, https://github.com/k8sgpt-ai/k8sgpt/pull/1115
  patch do
    url "https://github.com/k8sgpt-ai/k8sgpt/commit/1fb75a633c546bc6ada689e27d29c134d4cf8b5f.patch?full_index=1"
    sha256 "9ca5985449b404e4d12db2c3ce8823a18dc29fa9f8b391eb48c0de22400fe292"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end
