class InstaInfra < Formula
  desc "Spin up any service straight away on your local laptop"
  homepage "https://github.com/data-catering/insta-infra"
  url "https://github.com/data-catering/insta-infra/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "bd901cc3b85ba71515345329d049ddbe9a26bad1f8487602ff9e9432d9f34023"
  license "MIT"

  depends_on "docker" => :recommended
  depends_on "docker-compose" => :recommended
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "install", "github.com/data-catering/insta-infra/v2/cmd/insta@v2.0.1"
    bin.install buildpath/"bin/insta"
    prefix.install "docker-compose.yaml"
    prefix.install "docker-compose-persist.yaml"
    prefix.install "data"
    prefix.install "README.md"
  end

  def caveats
    <<~EOS
      To use insta-infra, run:
        insta <service-name>
      
      For help, run:
        insta help
      
      Persisted data will be stored in:
        #{prefix}/data/<service>/persist
    EOS
  end

  test do
    system "#{bin}/insta", "-l"
  end
end 
