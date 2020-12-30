{
	x = 0
	y = 0
	for (i = 1; i <= NF; ++i) {
		switch ($i) {
		case "e":
			++x
			break
		case "se":
			if (y % 2) {
				++x
			}
			++y
			break
		case "sw":
			if (! (y % 2)) {
				--x
			}
			++y
			break
		case "w":
			--x
			break
		case "nw":
			if (! (y % 2)) {
				--x
			}
			--y
			break
		case "ne":
			if (y % 2) {
				++x
			}
			--y
			break
		default:
			print "unknown direction", $i
			exit 1
		}
	}

	++tiles[x, y]
}

END {
	for (coord in tiles) {
		if (tiles[coord] % 2) {
			++count
		}
	}

	print count
}
