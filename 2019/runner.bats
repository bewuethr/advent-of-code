#!/usr/bin/env bats

@test "Run all days" {
	for d in day??/{first,second}; do
		cd "$d"
		run go run day???.go
		echo "$d"
		cmp <(echo "$output") output
		cd "$OLDPWD"
	done
}
