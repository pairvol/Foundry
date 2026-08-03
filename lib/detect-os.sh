#!/usr/bin/env bash
# Shared by every install-*.sh script: decides apt vs flatpak, without
# hardcoding "bazzite" specifically -- /run/ostree-booted (or rpm-ostree
# being present) is true for *any* rpm-ostree atomic system (Bazzite,
# Silverblue, Kinoite, uCore, ...), so this generalizes past just one distro.
#
# Usage:
#   source lib/detect-os.sh
#   case "$(detect_install_method)" in
#     apt)     ... ;;
#     flatpak) ... ;;
#     *)       echo "Unsupported system" >&2; exit 1 ;;
#   esac
detect_install_method() {
    if [ -f /run/ostree-booted ] || command -v rpm-ostree >/dev/null 2>&1; then
        echo "flatpak"
    elif command -v apt >/dev/null 2>&1; then
        echo "apt"
    else
        echo "unsupported"
    fi
}
