class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/h4kbas/lazygit"
  head "https://github.com/h4kbas/lazygit.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"lazygit", "-ldflags",
           "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  test do
    system "#{bin}/lazygit", "--version"
  end
end
