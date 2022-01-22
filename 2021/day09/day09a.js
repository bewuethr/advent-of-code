#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

let input = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n")
	.map(e => e.split("").map(Number));

let lows = [];

for (let y = 0; y < input.length; ++y) {
	for (let x = 0; x < input[y].length; ++x) {
		let val = input[y][x];
		if ((y == 0 || input[y-1][x] > val)
			&& (x == 0 || input[y][x-1] > val)
			&& (x == input[y].length - 1 || input[y][x+1] > val)
			&& (y == input.length - 1 || input[y+1][x] > val))
		{
			lows.push(val);
		}
	}
}

console.log(lows.map(e => e + 1).reduce((a, b) => a + b));

