class Xastir < Formula
  desc "X amateur station tracking and information reporting"
  homepage "http://www.xastir.org/"
  url "https://downloads.sourceforge.net/xastir/xastir-2.0.6.tar.gz"
  sha256 "e46debd3f67ea5c08e2f85f03e26653871a9cdd6d692c8eeee436c3bc8a8dd43"
  revision 4

  bottle do
    sha256 "8ec3b60269c896fde94b11f997d6dababdb100851ce184e17f0196b7a740e38f" => :el_capitan
    sha256 "d88601d7d756ee5bd3289135d997839b18339d1eab4a54f83bfc9f817690b831" => :yosemite
    sha256 "2fe492d1d4ca029908521c6cd358b055937148e623859c70009e2387758afba4" => :mavericks
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
