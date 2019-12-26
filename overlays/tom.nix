self: super: {
  tom = super.tom or {} // {
    emacs = self.emacs;
    nix = self.nix;
    conda = self.conda;
    slack = self.slack;
    gnupg = self.gnupg;
    pass = self.pass;
  };
}
