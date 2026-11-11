# NixOS dotfiles

Declarative NixOS configuration, currently targeting a UTM virtual machine on Apple Silicon.

- **NixOS** with Flakes
- **Home Manager** for user-level configuration (user `foiki`)
- **Sway** as the Wayland compositor, started from the **ReGreet** login screen
- **foot** as the terminal, **fuzzel** as the launcher
- **Bash** as the shell

## Repository structure

```text
dotfiles/
├── flake.nix                         # entry point: nixosConfigurations.nixos-vm
├── hosts/
│   └── nixos-vm/
│       ├── configuration.nix         # system level: boot, user, Sway, packages
│       └── hardware-configuration.nix  # generated per machine during install
├── home/
│   ├── foiki.nix                     # Home Manager: Sway config, bash, git, vim
│   └── programs/                     # per-program Home Manager modules
├── config/
│   ├── bash/aliases.bash             # sourced from ~/.bashrc via home/foiki.nix
│   ├── git/config                    # linked to ~/.config/git/config via home/foiki.nix
│   └── vim/vimrc                     # linked to ~/.vim/vimrc via home/foiki.nix
└── pre-nix/                          # old apt-based dotfiles, not used by the flake
```

## Install on an empty machine (UTM on Apple Silicon)

### 1. Create the VM

1. Download the **minimal ISO, aarch64** from <https://nixos.org/download/>.
2. In UTM, choose **Create a New Virtual Machine → Virtualize → Linux**. Select the ISO as the boot image.
3. Suggested resources: 4 CPU cores, 8 GB memory, 64 GB disk.
4. Start the VM. It boots into the installer and logs in as `nixos` automatically.
5. The installer uses a US keyboard layout. To switch to Swedish, run `sudo loadkeys sv-latin1`.

### 2. Partition and mount the disk

The VM disk is `/dev/vda` (check with `lsblk`). This wipes it:

```bash
sudo -i

parted /dev/vda -- mklabel gpt
parted /dev/vda -- mkpart root ext4 512MB 100%
parted /dev/vda -- mkpart ESP fat32 1MB 512MB
parted /dev/vda -- set 2 esp on

mkfs.ext4 -L nixos /dev/vda1
mkfs.fat -F 32 -n boot /dev/vda2

mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
```

### 3. Generate the hardware configuration

```bash
nixos-generate-config --root /mnt
```

This command writes `/mnt/etc/nixos/hardware-configuration.nix`, which you need. It also writes a `configuration.nix`, which you can ignore because this repo replaces it.

### 4. Clone the repo and add the hardware configuration

The installer has no `git`, so run it through `nix-shell`:

```bash
nix-shell -p git --run \
  "git clone https://github.com/foikila/dotfiles.git /mnt/home/foiki/dotfiles"

cp /mnt/etc/nixos/hardware-configuration.nix \
  /mnt/home/foiki/dotfiles/hosts/nixos-vm/hardware-configuration.nix
```

HTTPS needs no SSH key. You can switch to SSH later (see [Switch the remote to SSH](#switch-the-remote-to-ssh)).

### 5. Install

```bash
export NIX_CONFIG="experimental-features = nix-command flakes"
nixos-install --flake /mnt/home/foiki/dotfiles#nixos-vm
```

At the end, `nixos-install` asks for a **root** password. Then set the password for `foiki`:

```bash
nixos-enter --root /mnt -c 'passwd foiki'
```

### 6. Reboot

```bash
poweroff
```

In UTM, clear the CD/DVD drive so the VM no longer boots the ISO. Then start the VM again.

### 7. First login

The VM boots into the ReGreet login screen. Log in as `foiki` and Sway starts.

`Mod4` (Super/Cmd) + `Enter` opens foot, `Mod4+d` opens fuzzel, and `Mod4+Shift+e` exits back to the login screen. If the graphical login breaks, press `Ctrl+Alt+F2` to get a text console.

In foot, take ownership of the repo, which was cloned as root, and commit the hardware configuration:

```bash
sudo chown -R foiki:users ~/dotfiles
cd ~/dotfiles
git add hosts/nixos-vm/hardware-configuration.nix
git commit -m "Add hardware configuration for nixos-vm"
```

### Generate an SSH key

```bash
ssh-keygen -t ed25519 -a 100 -C "foiki@nixos-vm"
cat ~/.ssh/id_ed25519.pub
```

- `-t ed25519` uses a modern, short key type that's secure by default.
- `-a 100` makes the passphrase harder to brute-force if someone steals the private key.
- Set a passphrase when asked.
- Share only the `.pub` file. Never share `~/.ssh/id_ed25519`, which is the private key.

### Switch the remote to SSH

After you add the public key to GitHub (**Settings → SSH and GPG keys**):

```bash
ssh -T git@github.com    # should greet you by GitHub username
git remote set-url origin git@github.com:foikila/dotfiles.git
```

## Everyday workflow

Run these from `~/dotfiles`:

```bash
sudo nixos-rebuild switch --flake .#nixos-vm   # apply changes
sudo nixos-rebuild test --flake .#nixos-vm     # apply without making it the boot default
nix build .#nixosConfigurations.nixos-vm.config.system.build.toplevel  # build only
nix flake update                               # update nixpkgs / home-manager
sudo nixos-rebuild switch --rollback           # roll back
```

Flakes only see files tracked by git, so run `git add` on new files before you rebuild.

## Adding another machine

The flake has one host, `nixos-vm`. To add another machine:

1. Create `hosts/<name>/configuration.nix`. Start from a copy of `hosts/nixos-vm/configuration.nix` and change `networking.hostName` and anything VM-specific (`services.spice-vdagentd`, the boot loader).
2. Add a `nixosConfigurations.<name>` entry in `flake.nix` with the right `system` (`aarch64-linux` or `x86_64-linux`).
3. Follow the install steps above. Copy the generated hardware configuration to `hosts/<name>/` and install with `#<name>`.

## Notes

- Commit `flake.lock` after the first build so dependency versions stay reproducible.
- Keep `system.stateVersion` and `home.stateVersion` unchanged after installation, even when you upgrade NixOS.
- Keep the nixpkgs and home-manager release branches in `flake.nix` matching.
- `hardware-configuration.nix` is specific to each machine. Generate it on the machine itself.
- UTM clipboard sharing uses the SPICE agent (`services.spice-vdagentd`; enable the SPICE Agent device in the UTM VM settings). It has traditionally relied on an X session, so test copying between the host and guest in both directions under Sway.
