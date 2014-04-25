# With tmux, /etc/profile (and any per-user files) gets re-sourced. On OS X,
# /etc/profile uses a utility /usr/libexec/path_helper to prepend all the
# system default directories (/bin, /usr/bin, etc) to PATH no matter what's in
# PATH already. This breaks tools like rbenv because now /usr/bin/ruby comes
# before anything else in PATH. When our .bashrc runs after /etc/profile and
# .bash_profile, rbenv doesn't prepend anything to PATH because it is already
# present in PATH, albeit after /usr/bin. So, the best solution without messing
# with /etc/profile is to clear out PATH and re-source /etc/profile so that
# rbenv can later still prepend its paths into PATH.
if [ -f /etc/profile ]; then
    PATH=""
    source /etc/profile
fi

if [ -r ~/.bashrc ]; then
    . ~/.bashrc
fi
