#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

let input = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n")
	.map(e => e.split(" | "))
	.map(([left, right]) =>
		({
			patterns: left.split(" ")
				.map(e => e.split("").sort().join("")),
			output: right.split(" ")
				.map(e => e.split("").sort().join(""))
		}));

console.log(input
	.map(({patterns, output}) => {
		// Map digits to known patterns
		let mapping = {
			1: patterns.filter(e => e.length == 2)[0],
			4: patterns.filter(e => e.length == 4)[0],
			7: patterns.filter(e => e.length == 3)[0],
			8: patterns.filter(e => e.length == 7)[0]
		};

		// Count occurrences
		let counts = patterns.join("").split("")
			.reduce((prev, curr) => {
				prev[curr] = prev[curr] ? prev[curr] + 1 : 1;
				return prev;
			}, {});

		let segments = {};

		// Map unambiguous characters to norm characters
		for (let [key, value] of Object.entries(counts)) {
			if (value == 6) {
				segments["b"] = key;
			}
			else if (value == 4) {
				segments["e"] = key;
			}
			else if (value == 9) {
				segments["f"] = key;
			}
		}

		// The part of "1" occurring 8 times is norm "c"
		if (counts[mapping[1][0]] == 8) {
			segments["c"] = mapping[1][0];
		}
		else {
			segments["c"] = mapping[1][1];
		}

		// The part of "7" that's not "c" or "f" is "a"
		segments["a"] = mapping[7]
			.split("")
			.filter(e => e != segments["c"] && e != segments["f"])[0];

		// The 6-segment pattern of which we know 5 segments is "0"; the
		// unknown segment is "g"
		mapping[0] = patterns.filter(e => e.length == 6
			&& e.split("")
				.reduce((prev, curr) =>
					prev + (Object.values(segments).includes(curr) ? 1 : 0),
				0) == 5)[0];
		segments["g"] = mapping[0]
			.split("")
			.filter(e => !Object.values(segments).includes(e))[0];

		// The only unmapped segment is "d"; take it from "8"
		segments["d"] = mapping[8]
			.split("")
			.filter(e => !Object.values(segments).includes(e))[0];

		// Map the rest manually
		mapping[2] = "acdeg".split("").map(e => segments[e]).sort().join("");
		mapping[3] = "acdfg".split("").map(e => segments[e]).sort().join("");
		mapping[5] = "abdfg".split("").map(e => segments[e]).sort().join("");
		mapping[6] = "abdefg".split("").map(e => segments[e]).sort().join("");
		mapping[9] = "abcdfg".split("").map(e => segments[e]).sort().join("");

		let toDigits = {};
		for (let [key, value] of Object.entries(mapping)) {
			toDigits[value] = key;
		}

		return Number(output.map(e => toDigits[e]).join(""));
	})
	.reduce((prev, curr) => prev + curr));
