#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

function print(num) {
	console.log(JSON.stringify(num));
}

function equal(num1, num2) {
	return JSON.stringify(num1) == JSON.stringify(num2);
}

function markToExplode(num, depth = 0) {
	// console.log(`depth: ${depth}; looking at:`);
	// print(num);

	if (typeof num == "number") return num;

	if (depth == 4) {
		// console.log("I would explode this:", num);
		return num.map(e => `{${e}}`);
	}

	let n = markToExplode(num[0], depth + 1);
	if (!equal(n, num[0])) return [n, num[1]];

	n = markToExplode(num[1], depth + 1);
	if (!equal(n, num[1])) return [num[0], n];

	return num;
}

function explode(num) {
	let marked = JSON.stringify(markToExplode(num));

	let left = marked.match(/(.*[^\d])(\d+)([^\d]+"\{)(\d+)(\}","\{\d+\}".*)/);
	if (left) {
		// console.log(left);
		marked = left[1]
			+ (Number(left[2]) + Number(left[4]))
			+ left.slice(3).join("");
	}

	let right = marked.match(/(.*"\{\d+\}","\{)(\d+)(\}"[^\d]+)(\d+)(.*)/);
	if (right) {
		// console.log(right);
		marked = right.slice(1, 4).join("")
			+ (Number(right[2]) + Number(right[4]))
			+ right[5];
	}

	return JSON.parse(marked.replace(/\[".*"\]/, 0));
}

let input = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n")
	.map(l => JSON.parse(l));

let num = input[0];

print(explode(num));
