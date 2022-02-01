#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

let [points, folds] = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n\n");

points = points
	.split("\n")
	.map(p => p.split(",").map(Number));

folds = folds
	.split("\n")
	.map(f => f.substring(11).split("="))
	.map(([axis, val]) => [axis, Number(val)]);

let folded = new Set();
let idx = folds[0][0] == "x" ? 0 : 1;
let fold = folds[0][1];

points.forEach(p => {
	let pNew = [...p];
	if (pNew[idx] > fold) {
		pNew[idx] -= 2 * (pNew[idx] - fold);
	}
	folded.add(JSON.stringify(pNew));
});

console.log(folded.size);
