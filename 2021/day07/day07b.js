#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

function cost(from, to) {
	let diff = Math.abs(from - to);
	return diff * (diff + 1) / 2;
}

let input = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split(",")
	.map(Number);

let range = input .reduce((prev, curr) => ({
	min: prev.min ? Math.min(prev.min, curr) : curr,
	max: prev.max ? Math.max(prev.max, curr) : curr
}));

let costs = [];
for (let pos = range.min; pos <= range.max; ++pos) {
	costs.push(input.reduce((prev, curr) => prev + cost(pos, curr), 0));
}

console.log(costs.reduce((prev, curr) => Math.min(prev, curr)));
