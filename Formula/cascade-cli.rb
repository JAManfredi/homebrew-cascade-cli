# Homebrew Formula for Cascade CLI
# 
# Install method 1 (download first):
# curl -O https://raw.githubusercontent.com/JAManfredi/cascade-cli/master/homebrew/cascade-cli.rb
# brew install cascade-cli.rb
# rm cascade-cli.rb
#
# Install method 2 (with tap - requires tap repository):
# brew tap JAManfredi/cascade-cli
# brew install cascade-cli

class CascadeCli < Formula
  desc "Git-based development workflow tool for managing stacked branches"
  homepage "https://github.com/JAManfredi/cascade-cli"
  license "MIT OR Apache-2.0"
  head "https://github.com/JAManfredi/cascade-cli.git", branch: "master"

  # Apple Silicon (ARM64) - Default
  if Hardware::CPU.arm?
    url "https://github.com/JAManfredi/cascade-cli/releases/download/v0.1.31/ca-macos-arm64.tar.gz"
    sha256 "0c072788fb43ca95ea5c9a8ac864269d09db4b057d90ad70b3f2bc6ba53db9e0"
    version "0.1.31"
  else
    # Intel (x64)
    url "https://github.com/JAManfredi/cascade-cli/releases/download/v0.1.31/ca-macos-x64.tar.gz"
    sha256 "8269fe8791f4099c933ab56b49c610f3309ca2c6c11b4ec7c4c87b3fe3358aa3"
    version "0.1.31"
  end

  depends_on "git"

  def install
    bin.install "ca"
    
    # Note: Shell completions will be added in future release
    # when completion generation in CI is fixed
  end

  def post_install
    puts <<~EOS
      Cascade CLI has been installed!
      
      Quick Start:
        1. Navigate to your Git repository: cd your-project
        2. Initialize Cascade: ca init
        3. Create your first stack: ca stack create "my-feature"
        4. Add commits to stack: ca stack push
      
      Learn More:
        ca --help                    # Show all commands
        ca doctor                    # Check system setup
        ca stack --help             # Stack management help
        
      Documentation:
        https://github.com/JAManfredi/cascade-cli/blob/main/docs/USER_MANUAL.md
        https://github.com/JAManfredi/cascade-cli/blob/main/docs/ONBOARDING.md
      
      Shell Completions:
        Completions are automatically installed for Bash, Zsh, and Fish.
        Restart your shell or source your profile to enable them.
    EOS
  end

  test do
    system "#{bin}/ca", "--version"
    system "#{bin}/ca", "--help"
    
    # Test basic functionality
    (testpath/"test-repo").mkpath
    cd testpath/"test-repo" do
      system "git", "init"
      system "git", "config", "user.name", "Test User"
      system "git", "config", "user.email", "test@example.com"
      system "echo 'test' > README.md"
      system "git", "add", "README.md"
      system "git", "commit", "-m", "Initial commit"
      
      # Test ca doctor (should detect git repo but no cascade config)
      output = shell_output("#{bin}/ca doctor 2>&1", 1)
      assert_match "Git repository:", output
    end
  end
end 