class Xastir < Formula
  desc "X amateur station tracking and information reporting"
  homepage "http://www.xastir.org/"
  url "https://downloads.sourceforge.net/xastir/xastir-2.0.6.tar.gz"
  sha256 "e46debd3f67ea5c08e2f85f03e26653871a9cdd6d692c8eeee436c3bc8a8dd43"
  revision 4

  bottle do
    sha256 "dae43f834813723c47c3707170081f24944d9d6d29de4029d004d93131b7f365" => :sierra
    sha256 "993c39f3bf26d9a712093a9c822e64e6e8159e2ae1c4af47d48908f704a0652e" => :el_capitan
    sha256 "4736b9e6cebb27089d6631bf155b406f3f32c8abc76f00c9c9da8c285790ab29" => :yosemite
  end

  depends_on "proj"
  depends_on "pcre"
  depends_on "berkeley-db"
  depends_on "gdal"
  depends_on "libgeotiff"
  depends_on "openmotif"
  depends_on "jasper"
  depends_on "graphicsmagick"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
