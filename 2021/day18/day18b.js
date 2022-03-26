#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

function equal(num1, num2) {
	return JSON.stringify(num1) == JSON.stringify(num2);
}

function markToExplode(num, depth = 0) {
	if (typeof num == "number") return num;

	if (depth == 4) {
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
		marked = left[1]
			+ (Number(left[2]) + Number(left[4]))
			+ left.slice(3).join("");
	}

	let right = marked.match(/(.*"\{\d+\}","\{)(\d+)(\}"[^\d]+)(\d+)(.*)/);
	if (right) {
		marked = right.slice(1, 4).join("")
			+ (Number(right[2]) + Number(right[4]))
			+ right[5];
	}

	return JSON.parse(marked.replace(/\[".*"\]/, 0));
}

function split(num) {
	let string = JSON.stringify(num);
	let match = string.match(/(.*?[^\d])(\d{2,})(.*)/);
	if (match) {
		string = match[1] + "["
			+ Math.floor(Number(match[2] / 2)) + ","
			+ Math.ceil(Number(match[2] / 2))
			+ "]" + match[3];
	}

	return JSON.parse(string);
}

function reduce(num) {
	for (;;) {
		let n = explode(num);
		if (!equal(num, n)) {
			num = n;
			continue;
		}

		n = split(num);
		if (equal(num, n)) break;
		num = n;
	}

	return num;
}

function add(num1, num2) {
	return reduce([num1, num2]);
}

function magnitude(num) {
	if (typeof num == 'number') return num;

	return 3 * magnitude(num[0]) + 2 * magnitude(num[1]);
}

let input = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n")
	.map(l => JSON.parse(l));

let max = 0;
for (let n1 of input) {
	for (let n2 of input) {
		if (equal(n1, n2)) continue;
		max = Math.max(max, magnitude(add(n1, n2)));
	}
}

console.log(max);
