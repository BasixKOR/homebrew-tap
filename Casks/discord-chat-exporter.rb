cask "discord-chat-exporter" do
  version "2.46"
  sha256 :no_check

  on_intel do
    url "https://github.com/Tyrrrz/DiscordChatExporter/releases/download/#{version}/DiscordChatExporter.osx-x64.zip"
  end

  on_arm do
    url "https://github.com/Tyrrrz/DiscordChatExporter/releases/download/#{version}/DiscordChatExporter.osx-arm64.zip"
  end

  name "DiscordChatExporter"
  desc "Export Discord chat logs to various formats"
  homepage "https://github.com/Tyrrrz/DiscordChatExporter"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "DiscordChatExporter.app"
end
