class InstaInfra < Formula
  desc "Spin up any service straight away on your local laptop"
  homepage "https://github.com/data-catering/insta-infra"
  license "MIT"
  version "v2.1.0"

  depends_on "docker" => :recommended
  depends_on "docker-compose" => :recommended

  if Hardware::CPU.arm?
    url "https://github.com/data-catering/insta-infra/releases/download/v2.1.1/insta-v2.1.1-darwin-arm64.tar.gz"
    sha256 "a8c4718894e5122970a670e5301e50fac9de1e270a57069660ee0ceb87d93212"
  else
    url "https://github.com/data-catering/insta-infra/releases/download/v2.1.1/insta-v2.1.1-darwin-amd64.tar.gz"
    sha256 "0fade0496df1507264b14a80a5b260c1846d3c4c7565c5d0669afa6c49316891"
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
