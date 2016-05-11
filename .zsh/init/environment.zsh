eval $(systemctl --user show-environment | sed "s/^/export /")
