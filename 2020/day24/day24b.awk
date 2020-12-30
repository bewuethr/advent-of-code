function count_black(tiles,   coord, count) {
	for (coord in tiles) {
		if (tiles[coord] == b) {
			++count
		}
	}

	return count
}

function set_neighbours_white(tiles,   coord, sep, x, y, i) {
	for (coord in tiles) {
		split(coord, sep, SUBSEP)
		x = sep[1]
		y = sep[2]

		if (y % 2) {
			for (i = 1; i <= 6; ++i) {
				if (! ((x + dx_odd[i], y + dy[i]) in tiles)) {
					tiles[x + dx_odd[i], y + dy[i]] = w
				}
			}
		}
		else {
			for (i = 1; i <= 6; ++i) {
				if (! ((x + dx_even[i], y + dy[i]) in tiles)) {
					tiles[x + dx_even[i], y + dy[i]] = w
				}
			}
		}
	}
}

function dump(tiles,   coord, x, y) {
	for (coord in tiles) {
		split(coord, sep, SUBSEP)
		x = sep[1]
		y = sep[2]

		printf "%d/%d: %s\n", x, y, tiles[coord]
	}
	print ""
}

function get_black_neighbours(tiles, x, y,   i, count) {
	if (y % 2) {
		for (i = 1; i <= 6; ++i) {
			if ((x + dx_odd[i], y + dy[i]) in tiles) {
				count += tiles[x + dx_odd[i], y + dy[i]] == b
			}
		}
	}
	else {
		for (i = 1; i <= 6; ++i) {
			if ((x + dx_even[i], y + dy[i]) in tiles) {
				count += tiles[x + dx_even[i], y + dy[i]] == b
			}
		}
	}

	return count
}

function copy(arr1, arr2,   i) {
	for (i in arr1) {
		arr2[i] = arr1[i]
	}
}

function update_tiles(tiles,   tiles_cpy, coord, b_count, sep, x, y) {
	# Copy tiles
	copy(tiles, tiles_cpy)

	# For each original tile, loop over neighbours and count black tiles (rest
	# is white)
	for (coord in tiles) {
		split(coord, sep, SUBSEP)
		x = sep[1]
		y = sep[2]
		b_count = get_black_neighbours(tiles, x, y)

		# Update tile in copy according to rules
		if (tiles[coord] == b && (b_count == 0 || b_count > 2)) {
			tiles_cpy[coord] = w
		}
		if (tiles[coord] == w && b_count == 2) {
			tiles_cpy[coord] = b
		}
	}

	# Copy back to oririnal array
	copy(tiles_cpy, tiles)
}

BEGIN {
	b = "black"
	w = "white"

	dx_even[1] = 1
	dx_even[2] = 0
	dx_even[3] = -1
	dx_even[4] = -1
	dx_even[5] = -1
	dx_even[6] = 0

	dx_odd[1] = 1
	dx_odd[2] = 1
	dx_odd[3] = 0
	dx_odd[4] = -1 
	dx_odd[5] = 0 
	dx_odd[6] = 1 
	
	dy[1] = 0
	dy[2] = 1
	dy[3] = 1
	dy[4] = 0
	dy[5] = -1
	dy[6] = -1
}

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

	tiles[x, y] = tiles[x, y] == b ? w : b
}

END {
	for (i = 1; i <= 100; ++i) {
		set_neighbours_white(tiles)
		update_tiles(tiles)
	}

	print count_black(tiles)
}
