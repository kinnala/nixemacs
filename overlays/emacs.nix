self: super: {
  emacs_config = self.writeText "default.el" (builtins.readFile ./emacs/init.el);
  emacs = self.emacsWithPackages (epkgs: (with epkgs.melpaPackages; [
    use-package
    hydra
    ivy
    counsel
    swiper
    transient
    magit
    which-key
    exec-path-from-shell
    expand-region
    multiple-cursors
    json-mode
    leuven-theme
    highlight-indentation
    yaml-mode
    wgrep
    phi-search
    docker
    restclient
    ob-restclient
    htmlize
    diredfl
    python-pytest
    dired-k
    nix-mode
    anaconda-mode
    ivy-pass
  ]) ++ (with epkgs.elpaPackages; [
    csv-mode
    org
  ]) ++ [ (self.runCommand "default.el" {} ''
mkdir -p $out/share/emacs/site-lisp
cp ${self.emacs_config} $out/share/emacs/site-lisp/default.el
'') ]);
}
