self: super: {
  tom = super.tom or {} // {
    emacs = self.emacs;
    nix = self.nix;
    conda = self.conda;
    slack = self.slack;
    gnupg = self.gnupg;
    pass = self.pass;
    ripgrep = self.ripgrep;
    vim = self.vim;
    htop = self.htop;
    gmsh = self.gmsh;
    suitesparse = self.suitesparse;
  };
}
