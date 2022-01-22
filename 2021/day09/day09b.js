#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

function neighbours(p) {
	let n = [];
	if (p.y > 0) n.push({x: p.x, y: p.y - 1});
	if (p.y < m.length - 1) n.push({x: p.x, y: p.y + 1});
	if (p.x > 0) n.push({x: p.x - 1, y: p.y});
	if (p.x < m[0].length - 1) n.push({x: p.x + 1, y: p.y});

	n =  n.filter(p => !seen.has(JSON.stringify(p)) && m[p.y][p.x] != 9);
	n.forEach(p => seen.add(JSON.stringify(p)));
	return n;
}

let m = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n")
	.map(e => e.split("").map(Number));

let seen = new Set();
let sizes = [];

for (let y = 0; y < m.length; ++y) {
	for (let x = 0; x < m[y].length; ++x) {
		if (m[y][x] == 9 || seen.has(JSON.stringify({x, y}))) continue;

		let work = [{x, y}];
		seen.add(JSON.stringify({x, y}));
		let size = 0;
		while (work.length > 0) {
			++size;
			let curr = work.shift();
			work.push(...neighbours(curr));
		}

		sizes.push(size);
	}
}

console.log(sizes
	.sort((a, b) => b - a)
	.slice(0, 3)
	.reduce((a, b) => a * b, 1));
