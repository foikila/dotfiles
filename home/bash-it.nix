{ pkgs, lib, bash-it, ... }:

# Bash-it, pinned through the flake input. Its tree is read-only in the Nix
# store, so `bash-it enable/disable/update` don't work: edit `components` and
# rebuild instead.
let
  # <folder>/<file> inside Bash-it; browse the */available/ folders for more.
  components = [
    "aliases/git.aliases.bash"
    "plugins/history.plugin.bash"
    "completion/git.completion.bash"
    "completion/ssh.completion.bash"
    "completion/terraform.completion.bash"
    "completion/go.completion.bash"
    "completion/npm.completion.bash"
  ];

  # Bash-it's default load priorities (lib/helpers.bash).
  priority = {
    aliases = "750";
    plugins = "250";
    completion = "350";
  };

  # Same enabled/ symlinks `bash-it enable` would create.
  bashIt = pkgs.runCommand "bash-it" { } ''
    cp -r ${bash-it} $out
    chmod -R u+w $out
    mkdir -p $out/enabled
    ${lib.concatMapStrings (c: ''
      ln -s ../${dirOf c}/available/${baseNameOf c} $out/enabled/${priority.${dirOf c}}---${baseNameOf c}
    '') components}
  '';
in
{
  # mkBefore: load Bash-it first so config/bash/aliases.bash can override it.
  programs.bash.initExtra = lib.mkBefore ''
    export BASH_IT=${bashIt}
    export BASH_IT_THEME=bobby
    source "$BASH_IT/bash_it.sh"
  '';
}
