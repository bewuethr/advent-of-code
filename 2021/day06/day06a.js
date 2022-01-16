#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

function update(state) {
	let zeroes = state.filter(e => e == 0).length;
	let newState = state.map(e => e == 0 ? 6 : e -1);

	return newState.concat(Array(zeroes).fill(8));
}

let state = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split(",");

const days = 80;

for (let i = 0; i < days; ++i) {
	state = update(state);
}

console.log(state.length);
