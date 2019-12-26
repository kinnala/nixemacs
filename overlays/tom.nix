self: super: {
  tom = super.tom or {} // {
    emacs = self.emacs;
    nix = self.nix;
    conda = self.conda;
    slack = self.slack;
    google-chrome = self.google-chrome;
    gnupg = self.gnupg;
    pass = self.pass;
  };
}
