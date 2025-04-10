class InstaInfra < Formula
  desc "Spin up any service straight away on your local laptop"
  homepage "https://github.com/data-catering/insta-infra"
  license "MIT"

  depends_on "docker" => :recommended
  depends_on "docker-compose" => :recommended

  if Hardware::CPU.arm?
    url "https://github.com/data-catering/insta-infra/releases/download/v2.1.0/insta-v2.1.0-darwin-arm64.tar.gz"
    sha256 "8a0398b72f433534742d6450560cca32ef721b9d9fafc4a8af7901fca2edb122"
  else
    url "https://github.com/data-catering/insta-infra/releases/download/v2.1.0/insta-v2.1.0-darwin-amd64.tar.gz"
    sha256 "0a6b3eecc6c83b204f8df67d943040f4b0d49161e5ec7f9c0c55c908407b7ca0"
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
