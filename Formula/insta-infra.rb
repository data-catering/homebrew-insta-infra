class InstaInfra < Formula
  desc "Spin up any service straight away on your local laptop"
  homepage "https://github.com/data-catering/insta-infra"
  license "MIT"
  version "v2.1.2"

  depends_on "docker" => :recommended
  depends_on "docker-compose" => :recommended

  if Hardware::CPU.arm?
    url "https://github.com/data-catering/insta-infra/releases/download/v2.1.2/insta-v2.1.2-darwin-arm64.tar.gz"
    sha256 "5b87f543e269387a019dde5fb7332b461cc679f213055ff6998f8cea10ed11ac"
  else
    url "https://github.com/data-catering/insta-infra/releases/download/v2.1.2/insta-v2.1.2-darwin-amd64.tar.gz"
    sha256 "0a2e40fbfd5f874e7aea364a29f6328164aa6dd3e9cccaf9faf27c69b1d86214"
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
