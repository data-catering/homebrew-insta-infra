class InstaInfra < Formula
  desc "Spin up any service straight away on your local laptop"
  homepage "https://github.com/data-catering/insta-infra"
  license "MIT"
  version "v2.1.3"

  depends_on "docker" => :recommended
  depends_on "docker-compose" => :recommended

  if Hardware::CPU.arm?
    url "https://github.com/data-catering/insta-infra/releases/download/v2.1.3/insta-v2.1.3-darwin-arm64.tar.gz"
    sha256 "228f92f12e5a380bbeac80b4f88aaf26f219842354138c7f5cda441df8f6a48f"
  else
    url "https://github.com/data-catering/insta-infra/releases/download/v2.1.3/insta-v2.1.3-darwin-amd64.tar.gz"
    sha256 "e776521b0e37216f302f14f9bbf5f2c2fc5ea5f5e7a73a7e92b21b6efe15ecf4"
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
