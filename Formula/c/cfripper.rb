class Cfripper < Formula
  include Language::Python::Virtualenv

  desc "Library and CLI tool to analyse CloudFormation templates for security issues"
  homepage "https://cfripper.readthedocs.io"
  url "https://files.pythonhosted.org/packages/5a/9e/10c5c767e221e6b1cf5cd7562bcf535997b0ca8483c9c0ec62154d01911d/cfripper-1.15.4.tar.gz"
  sha256 "09f49b414708bf4f210bb728c3d9e0eed9823c3e2c9fd840eb34a4e1f92375f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03a964032e42370cd1929d66cf14490b2140cb68dc0560e995698988904b5ba7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "803f9f1c7ece274822ebaa909ecdade8b85f5b4d109d2951127009276684ddda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e11a62db16379fc07a4829284909b25a29c4511e38a4f466f44433361cd37172"
    sha256 cellar: :any_skip_relocation, sonoma:         "be0a0b0c49a3c5f5c86783ef39d2445eb5eb1aa6c38c9d2a2e7ddec540abee78"
    sha256 cellar: :any_skip_relocation, ventura:        "d866f57658e71663cc162ee22e10620bfeb12424aac8e312c8d450afd4745d96"
    sha256 cellar: :any_skip_relocation, monterey:       "54f8b4f2b0001aa9e6d6c7b893a7d832d8ef47b13112f257fbee24085da4f58c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44919b7bf64cf5f4eed40e953c930d83b13fab090d946a5d51e77b2cb6120bf3"
  end

  depends_on "python-click"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/0d/4d/a098b0b06b28043078e34b07e12e958cbea288e19454b83b1c22efc68719/boto3-1.34.40.tar.gz"
    sha256 "81d026ed8c8305b880c71f9f287f9b745b52bd358a91cfc133844c907db4d7ee"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/2b/7e/3ec86e69e49ce314f680280449189c05609c0801ad549bd53d2af612f6df/botocore-1.34.40.tar.gz"
    sha256 "cb794bdb5b3d41845749a182ec93cb1453560e52b97ae0ab43ace81deb011f6d"
  end

  resource "cfn-flip" do
    url "https://files.pythonhosted.org/packages/ca/75/8eba0bb52a6c58e347bc4c839b249d9f42380de93ed12a14eba4355387b4/cfn_flip-1.3.0.tar.gz"
    sha256 "003e02a089c35e1230ffd0e1bcfbbc4b12cc7d2deb2fcc6c4228ac9819307362"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
  end

  resource "pycfmodel" do
    url "https://files.pythonhosted.org/packages/de/7a/bab391457bd63298866854a203d243e794f779d933b468211712c62f84fb/pycfmodel-0.22.0.tar.gz"
    sha256 "af07ea1dd2f8c4f5f187595e420ba841f30bce4e785ecab17d68248e64085a52"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/df/ab/67eda485b025e9253cce0eaede9b6158a08f62af7013a883b2c8775917b2/pydantic-1.10.14.tar.gz"
    sha256 "46f17b832fe27de7850896f3afee50ea682220dd218f7e9c88d436788419dca6"
  end

  resource "pydash" do
    url "https://files.pythonhosted.org/packages/1a/15/dfb29b8c49e40b9bfd2482f0d81b49deeef8146cc528d21dd8e67751e945/pydash-7.0.7.tar.gz"
    sha256 "cc935d5ac72dd41fb4515bdf982e7c864c8b5eeea16caffbab1936b849aaa49a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a0/b5/4c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40ba/s3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.json").write <<~EOS
      {
        "AWSTemplateFormatVersion": "2010-09-09",
        "Resources": {
          "RootRole": {
            "Type": "AWS::IAM::Role",
            "Properties": {
              "AssumeRolePolicyDocument": {
                "Version": "2012-10-17",
                "Statement": [
                  {
                    "Effect": "Allow",
                    "Principal": {
                      "AWS": "arn:aws:iam::999999999:role/someuser@bla.com"
                    },
                    "Action": "sts:AssumeRole"
                  }
                ]
              },
              "Path": "/",
              "Policies": []
            }
          }
        }
      }
    EOS

    output = shell_output("#{bin}/cfripper #{testpath}/test.json --format txt 2>&1")
    assert_match "no AWS Account ID was found in the config.", output
    assert_match "Valid: True", output

    assert_match version.to_s, shell_output("#{bin}/cfripper --version")
  end
end
