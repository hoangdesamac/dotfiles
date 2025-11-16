if status is-interactive
    # Commands to run in interactive sessions can go here
    oh-my-posh init fish --config ~/.cache/oh-my-posh/themes/amro.omp.json | source
    set fish_greeting

    # Only mount if not already mounted

end
