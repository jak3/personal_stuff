#!/bin/zsh

ask() {
	echo -n "$@ [y/n] " ; read ans
	case "$ans" in
		y*|Y*) return 0 ;;
	*) return 1 ;;
esac
}

git-diff-files(){

	local prefix="[i] "
	local YN
	local files
	local f
	local arg

	if (( ! $# )); then
		echo "Usage: $0 [file1 file2 ... fileN]"
		return 1
	fi

	for arg in "$@"; do
		files=("${(f)$(< $arg)}")

		for f in $files; do
			git diff "HEAD^" HEAD $f

			if ask "${prefix} Generate $f.diff?"; then
			  git diff "HEAD^" HEAD $f > $f.diff
			fi

			if ask "${prefix} Exit?"; then
        echo "$prefix Ended."
				return 0
			fi
		done
	done

}

