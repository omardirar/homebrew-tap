class Taskpad < Formula
  desc "simple task runner terminal UI"
  homepage "https://github.com/omardirar/taskpad"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/omardirar/taskpad/releases/download/v0.1.0/taskpad-aarch64-apple-darwin.tar.xz"
      sha256 "441efce5662bcd429aad10749a06d161bb6baf6757b2e1b46eaacc0d9131a7fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omardirar/taskpad/releases/download/v0.1.0/taskpad-x86_64-apple-darwin.tar.xz"
      sha256 "b8b3be67c71011deb198d3d117a9f356ca617da6ea731676d3040ef8c7ebc854"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/omardirar/taskpad/releases/download/v0.1.0/taskpad-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "da3d0823e826bc6790665d49d082f36361355ed6c24692b497363dfc97ba1fc0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/omardirar/taskpad/releases/download/v0.1.0/taskpad-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7bc775fc846c34bd3d0f20147c81672b678dd7c7f46759b68a3019c396b8541e"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-pc-windows-gnu":            {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "taskpad" if OS.mac? && Hardware::CPU.arm?
    bin.install "taskpad" if OS.mac? && Hardware::CPU.intel?
    bin.install "taskpad" if OS.linux? && Hardware::CPU.arm?
    bin.install "taskpad" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
