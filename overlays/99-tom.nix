self: super: {
  tom = super.tom or {} // {
    emacs = self.lowPrio self.emacs;
    emacs-custom-desktop = self.emacs-custom-desktop;
    nix = self.nix;
    conda = self.conda;
    slack = self.slack;
    gnupg = self.gnupg;
    pass = self.pass;
    ripgrep = self.ripgrep;
    htop = self.htop;
    gmsh = self.gmsh;
    suitesparse = self.suitesparse;
    gnumake = self.gnumake;
  };
}
