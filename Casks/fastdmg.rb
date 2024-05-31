cask "fastdmg" do
  version "1.0.2"
  sha256 "405c99ee251ebe1a5f3e4cbec8b84e6211ee8b89e5abf0f50b7b2cee9567062a"

  url "https://sveinbjorn.org/files/software/fastdmg/FastDMG-#{version}.zip"
  name "FastDMG"
  desc "Replaces the system default DMG mounting application; is better in every way."
  homepage "https://sveinbjorn.org/fastdmg"

  livecheck do
    url "https://sveinbjorn.org/files/software/FastDMG.zip"
    strategy :header_match
  end

  app "FastDMG.app"
end
