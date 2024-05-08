class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/refs/tags/v1.6.27.tar.gz"
  sha256 "211618132974a864e3451ecd5c81a6dc7a361456b5e7d97a23f212ad8f6abb2d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61d2f14eed714017d3d53ddd4fe6666c8dfa2e2f8044a154e7cb5d8bbc718496"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e676462ab3f966a1121361e7b1a294176fc063d332ae4ceac0bc57db457aa36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "480ccff8d4c16bb86183644f15d8cbd715254ce14a8029ee9144bae89a71a5a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "09ce14e67ba47deadb63819ea850d69ba34e53d3f652ce5510a9520c2f389de8"
    sha256 cellar: :any_skip_relocation, ventura:        "62f5277a6bae988b32dff663c1094dc7da1e7b0f042d95b5b1cca0a224d52108"
    sha256 cellar: :any_skip_relocation, monterey:       "22b212529e48eca5cb0cbb6c2cd034a19f60b5a5314e386dad340e70acb2f792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa3c5f07b0f59c71bdaea2199b619833f09d8339dcc6c63a63c1a8c12b937393"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  # Support permissions for attestations
  patch do
    url "https://github.com/rhysd/actionlint/commit/1f0efe145326c0886ba32791ffc9d70e12ae6107.patch?full_index=1"
    sha256 "e42a59a65c274ebff7ae28e012cf0c1c136c26f6bbfe56133611b52e5d2ec7bc"
  end

  def install
    ldflags = "-s -w -X github.com/rhysd/actionlint.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/actionlint"
    system "ronn", "man/actionlint.1.ronn"
    man1.install "man/actionlint.1"
  end

  test do
    (testpath/"action.yaml").write <<~YAML
      name: Test
      on: push
      jobs:
        test:
          permissions:
            attestations: write
          steps:
            - run: actions/checkout@v2
    YAML

    output = shell_output("#{bin}/actionlint #{testpath}/action.yaml", 1)
    assert_match "\"runs-on\" section is missing in job", output
    refute_match "unknown permission scope", output
  end
end
