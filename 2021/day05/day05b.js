#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

let input = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n")
	.map(line => {
		let [x1, y1, x2, y2] = line.split(/[, >-]+/).map(Number);
		return {x1, y1, x2, y2};
	});

let points = input.map(({x1, y1, x2, y2}) => {
	let dx = x1 < x2 ? 1
		: x1 > x2 ? -1
		: 0;
	let dy = y1 < y2 ? 1
		: y1 > y2 ? -1
		: 0;

	let p = [];
	let x = x1, y = y1;
	for (; x != x2 || y != y2; x += dx, y += dy) {
		p.push({x, y});
	}
	p.push({x, y}); // add last point
	return p;
}).flat();

let counts = Object.create(null);
for (let p of points) {
	let pCount = counts[JSON.stringify(p)];
	counts[JSON.stringify(p)] = pCount ? pCount + 1 : 1;
}

let overlaps = Object.values(counts)
	.filter(v => v > 1)
	.length;

console.log(overlaps);
