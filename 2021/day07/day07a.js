#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

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
	costs.push(input.reduce((prev, curr) => prev + Math.abs(pos - curr), 0));
}

console.log(costs.reduce((prev, curr) => Math.min(prev, curr)));
