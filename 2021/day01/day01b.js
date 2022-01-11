#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

console.log(fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n")
	.map(Number)
	.map((el, idx, arr) => arr[idx-3] && el > arr[idx-3] ? 1 : 0)
	.reduce((prev, curr) => prev + curr));
