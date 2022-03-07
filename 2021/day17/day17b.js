#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

function update({x, y, dx, dy}) {
	return {
		x: x + dx,
		y: y + dy,
		dx: dx > 0 ? dx - 1 :
			dx < 0 ? dx = 1 : 0,
		dy: dy -1
	};
}

function inTarget({x, y}) {
	return x >= xMin && x <= xMax && y >= yMin && y <= yMax;
}

let [xMin, xMax, yMin, yMax] = [
	...fs.readFileSync(process.argv[2], "utf8")
		.trim()
		.matchAll(/-?\d+/g)
	].map(e => Number(e[0]));

let count = 0;

for (let dy = yMin; dy <= Math.abs(yMin - 1); ++dy) {
	for (let dx = 0; dx <= xMax; ++dx) {
		let proj = {x: 0, y: 0, dx, dy};
		for (;;) {
			proj = update(proj);
			if (proj.x > xMax || proj.y < yMin) break;

			if (inTarget(proj)) {
				++count;
				break;
			}
		}
	}
}

console.log(count);
