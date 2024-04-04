class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https://github.com/kubernetes-sigs/kustomize"
  url "https://github.com/kubernetes-sigs/kustomize.git",
      tag:      "kustomize/v5.4.0",
      revision: "31706fd7fdae9415d84bfbb66e2ede0f82c163ed"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomize/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be5524ae281ab055a6e21392462cc97c239ebbb17a25ec117362a664b581c803"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aec8134d77d8f2ef3e30ad84d162b251da036097460858463fabc1324ff97c5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "750ead5f441e9c8340513257f56931ee08d2869745614c6bd1dd6d7456b417da"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d6f7a8604d379bfdd284a53987cd0f3961ac24c1c4af1b94c247595e4b9612d"
    sha256 cellar: :any_skip_relocation, ventura:        "e3a923cfb3dfeddbd4c7ecdf4036fef5b4a68c403adccdba2838d0d3e1a7a885"
    sha256 cellar: :any_skip_relocation, monterey:       "f7d3631df4f73920fb44a519d1cd25f3da1810eb0198510c160467c18431651c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e11d48f2a0555e830e03647e8d61b5c7fa2c8b5ef80388633edb95cd7b6a589"
  end

  depends_on "go" => :build

  def install
    cd "kustomize" do
      ldflags = %W[
        -s -w
        -X sigs.k8s.io/kustomize/api/provenance.version=#{name}/v#{version}
        -X sigs.k8s.io/kustomize/api/provenance.buildDate=#{time.iso8601}
      ]

      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"kustomize", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/kustomize version")

    (testpath/"kustomization.yaml").write <<~EOS
      resources:
      - service.yaml
      patches:
      - path: patch.yaml
    EOS
    (testpath/"patch.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        selector:
          app: foo
    EOS
    (testpath/"service.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    EOS
    output = shell_output("#{bin}/kustomize build #{testpath}")
    assert_match(/type:\s+"?LoadBalancer"?/, output)
  end
end
