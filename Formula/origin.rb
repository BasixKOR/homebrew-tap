class Origin < Formula
  desc "CLI for Cursor Origin repositories, pull requests and rulesets"
  homepage "https://cursor.com"
  version "2026.10.01-18-10-45-4a05741"

  # The upstream installer bakes in the release for each channel; track `stable`.
  livecheck do
    url "https://downloads.cursor.com/origin/install.sh"
    regex(/^\s*stable\)\s*\n\s*version="([^"]+)"/im)
  end

  on_macos do
    on_arm do
      url "https://downloads.cursor.com/co/#{version}/darwin-arm64/co.tar.gz"
      sha256 "64e2558616aa0b28b8b45666e2dde1ef30508c9ba662c59dcc0e3c3d3eb523e8"
    end
    on_intel do
      url "https://downloads.cursor.com/co/#{version}/darwin-x64/co.tar.gz"
      sha256 "bf622a891e050741b628ae5f8e9721ac57daab70df068796e41fa366f5ec5d30"
    end
  end

  on_linux do
    on_arm do
      url "https://downloads.cursor.com/co/#{version}/linux-arm64/co.tar.gz"
      sha256 "01b5ad534215d734ad0564896849e7c87f78909a6b28ebc0144853a4548d61de"
    end
    on_intel do
      url "https://downloads.cursor.com/co/#{version}/linux-x64/co.tar.gz"
      sha256 "6732967be9d3d4453b2e2281019306bfb94ea4440fabcd11181cd81d6a02bafc"
    end
  end

  def install
    # The archive also ships a legacy `co` hard link; the upstream installer only exposes `origin`.
    libexec.install "origin"
    # Updates are managed by Homebrew, so silence the built-in `origin update` notifier.
    (bin/"origin").write_env_script libexec/"origin", CO_NO_UPDATE_NOTIFIER: "1"

    # yargs picks the completion script format from $SHELL.
    generate_completions_from_executable(bin/"origin", "completion",
                                         shell_parameter_format: :none, shells: [:bash, :zsh])
  end

  def caveats
    <<~EOS
      To sign in, run:
        origin auth login

      Update with `brew upgrade origin` rather than `origin update`.
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/origin --version").strip
  end
end
