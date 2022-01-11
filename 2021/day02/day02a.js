#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

let pos = 0;
let depth = 0;

fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n")
	.map(line => {
		let [instr, amount] = line.split(" ");
		return {instr, amount: Number(amount)}
	})
	.forEach(({instr, amount}) => {
		switch(instr) {
			case "forward":
				pos += amount;
				break;
			case "down":
				depth += amount;
				break;
			case "up":
				depth -= amount;
				break;
			default:
				console.error(`invalid instruction: ${instr}`);
		}
	});

console.log(pos * depth);
