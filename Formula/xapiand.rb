# Homebrew formula for Xapiand (build-from-source).
#
# This is the canonical source for the formula. To publish it, copy it into the
# tap repository the docs point at (github.com/Kronuz/homebrew-tap) as
# Formula/xapiand.rb, so `brew install Kronuz/tap/xapiand` resolves.
#
# This formula is intentionally head-only: it builds from source with no pinned
# stable version, so nothing here ever goes stale and there is no url/sha256 to
# bump. Install it locally with:
#
#     brew install --HEAD ./contrib/homebrew/xapiand.rb
#
# At release time the bottling workflow (.github/actions/build-bottle) copies this
# formula and injects the tag being built as a stable `url` + a fresh source
# `sha256`, so a release's bottles always come from that release's source. Nothing
# to bump by hand, ever.
class Xapiand < Formula
  desc "RESTful search engine"
  homepage "https://github.com/Kronuz/Xapiand"
  url "https://github.com/Kronuz/Xapiand/archive/refs/tags/v1.0.0-alpha.7.tar.gz"
  sha256 "2da6a87f12aa55dcec6ec4a671fe0a8f311d9bd120bc30bcb31042578804e63e"
  license "MIT"
  head "https://github.com/Kronuz/Xapiand.git", branch: "master"

  bottle do
    root_url "https://github.com/Kronuz/Xapiand/releases/download/v1.0.0-alpha.7"
    sha256 arm64_sequoia: "706b31966600d84806a6fdaafa66704d41aef9e3fb7bf52ccfbcdea6ad6ffc53"
    sha256 arm64_sonoma:  "080c141acaf4b5c2211820478e490005f8f100462bb7d86f95d7876565f7e885"
    sha256 sonoma:        "c7268495cacfbd1a01e8e91a7d69cd7a5246de8420d12d581f128490e3a1f287"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "tcl-tk" => :build
  depends_on "icu4c"
  depends_on "zstd"

  def install
    # icu4c is keg-only on Homebrew; point pkg-config (and thus CMake's ICU probe)
    # at it so the build finds ICU.
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig"
    # This formula fetches its Kronuz-family deps (and standalone Asio) via
    # FetchContent, which Homebrew traps by default. HOMEBREW_ALLOW_FETCHCONTENT is
    # Homebrew's sanctioned opt-out (the trap returns early when it's ON). Fine for
    # a personal tap, and it keeps the Asio version pinned by CMake (asio-1-36-0)
    # rather than tracking whatever Homebrew ships.
    system "cmake", "-S", ".", "-B", "build", "-GNinja",
           "-DCMAKE_BUILD_TYPE=Release",
           "-DCMAKE_CXX_STANDARD=20",
           "-DCMAKE_CXX_STANDARD_REQUIRED=ON",
           "-DLTO=OFF",
           "-DHOMEBREW_ALLOW_FETCHCONTENT=ON",
           *std_cmake_args
    # LTO is off for the bottle build: its per-TU bitcode makes the heavy TUs
    # (search_views.cc) memory-hungry enough to OOM the smaller macOS runners and
    # crawls on Intel. Bounding parallelism to Homebrew's job count is a further
    # safety net without changing the produced binaries.
    system "cmake", "--build", "build", "--parallel", ENV.make_jobs.to_s
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Xapiand", shell_output("#{bin}/xapiand --version")
  end
end
