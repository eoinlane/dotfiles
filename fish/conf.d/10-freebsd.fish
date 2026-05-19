if test (uname -s) = FreeBSD
    # Locale
    set -x TERM xterm-256color
    set -x LANG C.UTF-8
    set -x LC_ALL C.UTF-8

    # PATH (prepend useful dirs ahead of system PATH)
    set -x PATH /usr/local/bin /usr/local/sbin $HOME/.local/bin $HOME/bin $PATH

    # Julia depot
    set -x JULIA_DEPOT_PATH $HOME/julia/packages

    # Raspberry Pi share
    set -g RASP_MOUNT $HOME/raspberry
    set -g RASP_HOST eoin@raspberrypi
    set -g RASP_PATH /media/eoin/MyExternalDrive

    function mrasp
        if mount | grep -q $RASP_MOUNT
            echo "Already mounted at $RASP_MOUNT"
            return 0
        end
        echo "Mounting Raspberry Pi share..."
        if sshfs $RASP_HOST:$RASP_PATH $RASP_MOUNT -o idmap=user,reconnect,ServerAliveInterval=15
            echo "Mounted at $RASP_MOUNT"
        else
            echo "Mount failed." >&2
            return 1
        end
    end

    function umrasp
        if not mount | grep -q $RASP_MOUNT
            echo "Not currently mounted."
            return 0
        end
        echo "Unmounting $RASP_MOUNT..."
        if umount $RASP_MOUNT
            echo "Unmounted."
        else
            echo "Unmount failed (files open?)." >&2
            return 1
        end
    end

    function rasp
        if not mount | grep -q $RASP_MOUNT
            echo "Share not mounted. Run mrasp first."
            return 1
        end
        cd $RASP_MOUNT
    end

    # FreeBSD pkg helpers
    function pkgup
        sudo pkg update && sudo pkg upgrade -y
    end

    function pkgs
        pkg search $argv
    end

    # Start Pluto in the notebooks project
    function pluto
        set -l script ~/julia/projects/notebooks/start_pluto.jl
        if not test -x $script
            echo "Making $script executable..."
            chmod +x $script
        end
        echo "Starting Pluto via $script ..."
        $script $argv
    end

    # fzf key bindings (FreeBSD install locations)
    if status is-interactive
        if test -f /usr/local/share/fzf/shell/key-bindings.fish
            source /usr/local/share/fzf/shell/key-bindings.fish
        else if test -f /usr/local/share/fzf/key-bindings.fish
            source /usr/local/share/fzf/key-bindings.fish
        else if test -f /usr/local/share/examples/fzf/shell/key-bindings.fish
            source /usr/local/share/examples/fzf/shell/key-bindings.fish
        end
    end
end
