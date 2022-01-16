#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

function update(state) {
	let newState = Array(state.length).fill(0);

	let zeroes = state[0];
	for (let i = 0; i < 8; ++i) {
		newState[i] = state[i + 1];
	}

	newState[6] += zeroes;
	newState[8] += zeroes;

	return newState;
}

let state = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split(",")
	.reduce((prev, curr) => {
		prev[curr] = prev[curr] ? prev[curr] + 1 : 1;
		return prev;
	}, []);

for (let i = 0; i <= 8; ++i) {
	state[i] = state[i] ? state[i] : 0;
}

const days = 256;

for (let i = 0; i < days; ++i) {
	state = update(state);
}

console.log(Object.values(state).reduce((prev, curr) => prev + curr));
