# Create all templates

Install packages from local repo.

create sandbox templates:
435 ansible-nginx
917 ansible-repos
924 ansible-pkg-repo
928 ansible-init

create sandbox jails:
924 pkg-repo
917 repos
918 foo, bar
919 baz, qux
920 log-server, www-01, www-02
925 log-server, www-01, www-02

example jails:
435 www-01, www-02                   ansible-nginx
523 repos                            ansible-repos
524 foo, bar                         ansible-init
527 pkg-repo                         ansible-pkg-repo
528 log-server-01, www-01, www-02    ansible-init
