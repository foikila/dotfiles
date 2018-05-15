
DEFAULT_MENU="[begin] (fluxbox) \n
\n
[exec] (Intellij) { ~/.local/share/JetBrains/Toolbox/apps/IDEA-C/ch-0/181.4892.42/bin/idea.sh} \n
[exec] (Firefox) { firefox } \n
[exec] (Chrome) { google-chrome } \n
[exec] (SqlDeveloper) { sqldeveloper } \n
[exec] (VS code) { code -n } \n
[exec] (Atom) { atom -n } \n
[exec] (Terminal) { gnome-terminal } <>\n
\n
[submenu] (Kill) \n
    [exec] (Intellij) { pgrep  -f JetBrains | xargs kill } \n
    [exec] (Firefox) { pgrep  -f firefox | xargs kill } \n
[end]\n
\n
[nop]\n
\n
[include] (~/dotfiles/fluxbox/${HOSTNAME}.menu)\n
\n
[nop]\n
\n
[reconfig] (Reconfigure)\n
[restart] (Restart)\n
[exit] (Exit)\n
\n
\n
[end]\n"
