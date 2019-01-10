class Xapiand < Formula
  desc "Xapiand: A RESTful Search Engine"
  homepage "https://kronuz.io/Xapiand"
  url "https://github.com/Kronuz/Xapiand/archive/v0.8.8.tar.gz"
  sha256 "a2c32d11e8aabacfa0450a5c2b4eeb048fa9a34bd382bb4ed6580798b6ffb571"
  head "https://github.com/Kronuz/Xapiand.git"

  bottle do
    root_url "https://kronuz.io/homebrew-tap"
    cellar :any
    sha256 "771d95ef157738957e8b0d59927579b7ed75a226ff4cf45cc38878f84759a53c" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "kronuz/tap/xapian"

  def install
    mkdir "build" do
      system "cmake", "..", "-DCCACHE_FOUND=CCACHE_FOUND-NOTFOUND", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system bin/"xapiand", "--version"
  end
end
