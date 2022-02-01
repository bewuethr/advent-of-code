#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

let [input, folds] = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n\n");

let points = new Set();

input.split("\n")
	.map(p => p.split(",").map(Number))
	.forEach(p => points.add(JSON.stringify(p)));

folds = folds
	.split("\n")
	.map(f => f.substring(11).split("="))
	.map(([axis, val]) => [axis, Number(val)]);

folds.forEach(f => {
	let idx = f[0] == "x" ? 0 : 1;
	let fold = f[1];

	for (let point of points) {
		let p = JSON.parse(point);
		if (p[idx] > fold) {
			p[idx] -= 2 * (p[idx] - fold);
			points.delete(point);
			points.add(JSON.stringify(p));
		}
	}
})

// Get maximal coordinates for points
let max = [...points].map(JSON.parse)
	.reduce((max, curr) => {
		return {
			x: curr[0] > max.x ? curr[0] : max.x,
			y: curr[1] > max.y ? curr[1] : max.y
		};
	}, {x: 0, y: 0});

let grid = Array(max.y + 1).fill()
	.map(() => Array(max.x + 1).fill("."));

for (let point of points) {
	let [x, y] = JSON.parse(point);
	grid[y][x] = "#";
}

console.log(grid.map(a => a.join("")).join("\n"));
