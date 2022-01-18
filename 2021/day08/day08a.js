#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

let input = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n")
	.map(e => e.split(" | ")[1].split(" "))
	.flat()
	.filter(e =>
		e.length == 2 ||
		e.length == 3 ||
		e.length == 4 ||
		e.length == 7);

console.log(input.length);
