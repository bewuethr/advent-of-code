#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

function isValid(line) {
	let stack = [];
	for (let e of line.split("")) {
		if (e.match(/[[({<]/)) stack.push(e);
		else if (!pairs.includes(stack.pop() + e)) return false;
	}

	return true;
}

function getScore(line) {
	let scores = new Map();
	scores.set("(", 1);
	scores.set("[", 2);
	scores.set("{", 3);
	scores.set("<", 4);

	let stack = [];
	for (let e of line.split("")) {
		if (e.match(/[[({<]/)) stack.push(e);
		else stack.pop();
	}

	let score = 0;
	for (let e of stack.reverse()) {
		score *= 5;
		score += scores.get(e);
	}

	return score
}

let input = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n");

let pairs = ["()", "[]", "{}", "<>"];

let scores = input
	.filter(isValid)
	.map(getScore);

console.log(scores.sort((a, b) => a - b)[Math.floor(scores.length / 2)]);
