class Dooit < Formula
  include Language::Python::Virtualenv

  desc "TUI todo manager (h4kbas fork)"
  homepage "https://github.com/h4kbas/dooit"
  head "https://github.com/h4kbas/dooit.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  def install
    venv_python = Formula["python@3.14"].bin/"python3.14"
    system venv_python, "-m", "venv", libexec
    system libexec/"bin/python", "-m", "pip", "install", "--upgrade", "pip"
    system libexec/"bin/python", "-m", "pip", "install", buildpath
    system libexec/"bin/python", "-m", "pip", "install", "dooit-extras"
    bin.install_symlink libexec/"bin/dooit"
    generate_completions_from_executable(bin/"dooit", shell_parameter_format: :click)
  end

  test do
    system bin/"dooit", "--version"
  end
end
