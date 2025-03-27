class InstaInfra < Formula
  desc "Spin up any service straight away on your local laptop"
  homepage "https://github.com/data-catering/insta-infra"
  license "MIT"

  depends_on "docker" => :recommended
  depends_on "docker-compose" => :recommended

  if Hardware::CPU.arm?
    url "https://github.com/data-catering/insta-infra/releases/download/v2.0.1/insta-v2.0.1-darwin-arm64.tar.gz"
    sha256 "be76ef8c5251774b57ea858aec68019becc1d820f411a9f5872f1d3ca0689837"
  else
    url "https://github.com/data-catering/insta-infra/releases/download/v2.0.1/insta-v2.0.1-darwin-amd64.tar.gz"
    sha256 "577987842ce339b94c240f027de1f6286a41d09ddb14fc624fbf9522f4ca607b"
  end

  def install
    bin.install "insta"
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
