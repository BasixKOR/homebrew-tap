cask "mythic" do
  version "0.1.1-alpha"
  sha256 "a00e9990900e3f3e71d0c90f41c67fb7d4d318e283d326519767791e59eedc39"

  url "https://github.com/MythicApp/Mythic/releases/download/v#{version}/Mythic.zip",
    verified: "github.com/MythicApp/Mythic"
  name "Mythic"
  desc "A unique open-source game launcher for macOS with the ability to run Windows games."
  homepage "https://getmythic.app/"

  app "Mythic.app"
end

