#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

let yMin = Number(fs.readFileSync(process.argv[2], "utf8")
		.trim()
		.match(/-?\d+/g)[2]);

let dyInit = Math.abs(yMin) - 1;

console.log((dyInit * (dyInit + 1)) / 2);
