class Boat < Formula
  desc "CLI for Boat sandboxes and coding agents"
  homepage "https://boat.dev"
  version "1.0.31"
  license "MIT"

  livecheck do
    url :stable
    regex(/^boat-cli-v?(\d+(?:\.\d+)+)$/i)
  end

  on_macos do
    on_arm do
      url "https://github.com/ariana-dot-dev/agent-server/releases/download/boat-cli-v#{version}/boat-darwin-arm64"
      sha256 "fcf627f429fea9f98f2664719869379b98f6ea027573120a9f61b7a52e1eb535"
    end
    on_intel do
      url "https://github.com/ariana-dot-dev/agent-server/releases/download/boat-cli-v#{version}/boat-darwin-x64"
      sha256 "5eca5c764380eb3f18271256d4f1b318ab68ebadb66c04606820c808f2f282fb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ariana-dot-dev/agent-server/releases/download/boat-cli-v#{version}/boat-linux-arm64"
      sha256 "bb4620bd28f327a7db4a9c652ee4349a5138ded0323131648fbebc1378ed8c58"
    end
    on_intel do
      url "https://github.com/ariana-dot-dev/agent-server/releases/download/boat-cli-v#{version}/boat-linux-x64"
      sha256 "147e63d05e237f5531fc74bb4a1f5da703a1a943244a0e0c46cb58b0dd464e3e"
    end
  end

  # The release repo also hosts node-manager and `-staging` CLI builds;
  # only plain `boat-cli-vX.Y.Z` tags are what https://boat.dev/install serves (channel=prod).

  def install
    # Release assets are bare binaries without the executable bit (upstream installer chmods them).
    binary = File.basename(stable.url)
    chmod 0755, binary
    bin.install binary => "boat"

    # `--no-update` is a global flag; keeps the build from hitting the update-check endpoint.
    generate_completions_from_executable(bin/"boat", "--no-update", "completions")

    # Optional shell integration from the upstream installer: a `boat` function that
    # exports BOAT_CURRENT_ID / BOAT_CURRENT_CONVO so `current` works across commands.
    (pkgshare/"shell-integration.sh").write <<~SH
      # Boat shell integration (bash/zsh). Source this from ~/.bashrc or ~/.zshrc.
      boat() {
        current_file=$(mktemp)
        convo_file=$(mktemp)
        old_current_file=${BOAT_CURRENT_ID_FILE-}
        old_convo_file=${BOAT_CURRENT_CONVO_FILE-}
        export BOAT_CURRENT_ID_FILE="$current_file"
        export BOAT_CURRENT_CONVO_FILE="$convo_file"
        command boat "$@"
        boat_status=$?
        if [ "$boat_status" -eq 0 ]; then
          case "${1:-}" in
            new|start|fork)
              if [ -s "$current_file" ]; then
                current_id=$(tr -d '[:space:]' < "$current_file")
                if [ -n "$current_id" ]; then export BOAT_CURRENT_ID="$current_id"; fi
              fi
              ;;
          esac
          case "${1:-}" in
            prompt)
              if [ -s "$convo_file" ]; then
                IFS= read -r current_convo < "$convo_file" || current_convo=""
                if [ -n "$current_convo" ]; then export BOAT_CURRENT_CONVO="$current_convo"; fi
              fi
              ;;
          esac
        fi
        if [ -n "$old_current_file" ]; then export BOAT_CURRENT_ID_FILE="$old_current_file"; else unset BOAT_CURRENT_ID_FILE; fi
        if [ -n "$old_convo_file" ]; then export BOAT_CURRENT_CONVO_FILE="$old_convo_file"; else unset BOAT_CURRENT_CONVO_FILE; fi
        rm -f "$current_file" "$convo_file"
        return "$boat_status"
      }
    SH
  end

  def caveats
    <<~EOS
      To sign in and set up your account, run:
        boat onboard

      To let `boat new/fork` and `boat prompt` remember the "current" sandbox and
      conversation in your shell, add this to ~/.zshrc or ~/.bashrc:
        source #{opt_pkgshare}/shell-integration.sh

      Update with `brew upgrade boat` rather than `boat self-update`.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/boat --version")
  end
end
