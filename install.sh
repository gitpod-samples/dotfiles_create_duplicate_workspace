#!/usr/bin/env bash

function vsdup() {
	set -eu;
	if test -z "${1:-}"; then {
		# We could generate a random string but that might not be intuitive to work with
		printf 'error: %s\n' 'Please provide a string';
		exit 1;
	} fi

	local main_workdir="$GITPOD_REPO_ROOT";
	local dup_dir="${GITPOD_REPO_ROOT%/*}/$1";

	printf 'info: Copying %s into %s ...\n' "$main_workdir" "$dup_dir";
	rm -rf "$dup_dir";
	cp -ar "$main_workdir" "$dup_dir";

	printf 'info: Starting a new VSCode instance from %s\n' "$dup_dir";
	printf 'info: If it stays stuck here, try to reload the browser window and re-run this command\n';
	gp ports await 23000 1>/dev/null;
	code "$dup_dir";
	printf 'info: Successful\n'
	set +eu
}

target_bin="$HOME/.local/bin/vsdup"

printf '%s\n' '#!/usr/bin/bash' \
				"$(declare -f vsdup)" \
				'vsdup "$@"' > "$target_bin"
chmod +x "$target_bin";