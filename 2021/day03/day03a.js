#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

let report = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n")
	.map(el => el.split("").map(Number));

let len = report[0].length;

let gamma = report.reduce((prev, curr) => {
		curr.forEach((el, idx) => {
			prev[idx][el]++;
		});
		return prev;
	}, Array.from(Array(len), () => [0, 0]))
	.map(([zero, one]) => zero > one ? 0 : 1)
	.join("");

let epsilon = gamma.split("")
	.map(Number)
	.map((digit, idx) => gamma[idx] == 0 ? 1 : 0)
	.join("");

console.log(parseInt(gamma, 2) * parseInt(epsilon, 2));
