self: super: {
  tom = super.tom or {} // {
    emacs = self.emacs;
    nix = self.nix;
    conda = self.conda;
    google-chrome = self.google-chrome;
    git = self.git;
    slack = self.slack;
  };
}
