#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

let input = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split(",")
	.map(Number);

let fuel = input
	.map(pos => input
		.reduce((prev, curr) => prev + Math.abs(pos - curr), 0))
	.reduce((prev, curr) => Math.min(prev, curr));

console.log(fuel);
