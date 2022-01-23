#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

let input = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n");

let score = 0;
let pairs = ["()", "[]", "{}", "<>"];
let scores = new Map();
scores.set(")", 3);
scores.set("]", 57);
scores.set("}", 1197);
scores.set(">", 25137);

for (let line of input) {
	let stack = [];
	for (let e of line.split("")) {
		if (e.match(/[[({<]/)) stack.push(e);
		else if (!pairs.includes(stack.pop() + e)) {
			score += scores.get(e);
			break;
		}
	}
}

console.log(score);
