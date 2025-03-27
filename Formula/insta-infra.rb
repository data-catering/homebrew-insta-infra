class InstaInfra < Formula
  desc "Spin up any service straight away on your local laptop"
  homepage "https://github.com/data-catering/insta-infra"
  license "MIT"

  depends_on "docker" => :recommended
  depends_on "docker-compose" => :recommended

  if Hardware::CPU.arm?
    url "https://github.com/data-catering/insta-infra/releases/download/v2.0.2/insta-v2.0.2-darwin-arm64.tar.gz"
    sha256 "21aea9c5af275dd1b3ecb556be49c96e21fbad4f215bd9806bf409f150f75725"
  else
    url "https://github.com/data-catering/insta-infra/releases/download/v2.0.2/insta-v2.0.2-darwin-amd64.tar.gz"
    sha256 "b30bd85d5c9334fa560fa5b93a043e70ef2357ebb948318259965c0cf7c024ba"
  end

  def install
    system "tar", "-xzf", cached_download, "-C", buildpath
    binary_name = "insta-darwin-#{Hardware::CPU.arm? ? "arm64" : "amd64"}"
    bin.install buildpath/binary_name => "insta"
  end

  def caveats
    <<~EOS
      To use insta-infra, run:
        insta <service-name>
      
      For help, run:
        insta help

      To persist data between runs, use the -p flag:
        insta -p <service-name>

      Data will be stored in:
        ~/.insta/data/<service_name>/persist/
    EOS
  end

  test do
    system "#{bin}/insta", "-l"
  end
end 
