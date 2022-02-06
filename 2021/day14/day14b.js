#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

function step(pairs) {
	let newPairs = Object.create(null);

	for (let pair of Object.keys(pairs)) {
		let insert = rules[pair];
		let new1 = pair[0] + insert;
		let new2 = insert + pair[1];
		newPairs[new1] = newPairs[new1] ? newPairs[new1] + pairs[pair] : pairs[pair];
		newPairs[new2] = newPairs[new2] ? newPairs[new2] + pairs[pair] : pairs[pair];
	}

	return newPairs;
}

let [polymer, ruleInput] = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n\n");

let pairs = Object.create(null);
for (let i = 1; i < polymer.length; ++i) {
	let pair = polymer[i - 1] + polymer[i];
	pairs[pair] = pairs[pair] ? ++pairs[pair] : 1;
}

let rules = Object.create(null);
ruleInput.split("\n")
	.forEach(line => {
		let [from, to] = line.split(" -> ");
		rules[from] = to;
	});

for (let i = 0; i < 40; ++i) {
	pairs = step(pairs);
}

let ends = polymer[0] + polymer[polymer.length - 1];
let counts = Object.create(null);

for (let [[first, second], count] of Object.entries(pairs)) {
	counts[first] = counts[first] ? counts[first] + count : count;
	counts[second] = counts[second] ? counts[second] + count : count;
}


for (let [el, count] of Object.entries(counts)) {
	if (ends.includes(el)) {
		counts[el] = (count - 1) / 2 + 1;
		continue;
	}

	counts[el] /= 2;
}

let sorted = Object.values(counts).sort((a, b) => b - a);
console.log(sorted[0] - sorted[sorted.length - 1]);
