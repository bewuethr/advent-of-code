#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

let octos = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n")
	.map(l => l.split("").map(Number));

let count = 0;

for (let i = 0; i < 100; ++i) {
	let work = [];
	octos = octos.map((line, y) =>
		line.map((o, x) => {
			if (o >= 9) work.push({x, y});
			return o + 1;
		}));

	let flashed = new Set();

	while (work.length > 0) {
		let {x, y} = work.shift();
		if (flashed.has(JSON.stringify({x, y}))) continue;

		flashed.add(JSON.stringify({x, y}));
		for (let yy = y - 1; yy <= y + 1; ++yy) {
			for (let xx = x - 1; xx <= x + 1; ++xx) {
				if (yy < 0 || yy >= octos.length) continue;
				if (xx < 0 || xx >= octos[0].length) continue;
				if (yy == y && xx == x) continue;
				++octos[yy][xx];
				if (octos[yy][xx] > 9 &&
					!flashed.has(JSON.stringify({x: xx, y: yy})))
				{
					work.push({x: xx, y: yy});
				}
			}
		}
	}

	// Reset flashed octos to 0
	count += flashed.size;
	octos = octos.map(line => line.map(o => o > 9 ? 0 : o));
}

console.log(count);
