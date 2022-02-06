#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

function step(polymer) {
	let newPol = [];
	newPol.push(polymer.shift());

	let prev = newPol[0];

	for (let el of polymer) {
		newPol.push(rules[prev + el], el);
		prev = el;
	}

	return newPol;
}

let [polymer, ruleInput] = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n\n");

polymer = polymer.split("");

let rules = Object.create(null);

ruleInput.split("\n")
	.forEach(line => {
		let [from, to] = line.split(" -> ");
		rules[from] = to;
	});

for (let i = 0; i < 10; ++i) {
	polymer = step(polymer);
}

let counts = Object.values(polymer
	.reduce((counts, curr) => {
		counts[curr] = counts[curr] ? counts[curr] + 1 : 1;
		return counts;
	}, Object.create(null)))
	.sort((a, b) => b - a);
	
console.log(counts[0] - counts[counts.length - 1]);
