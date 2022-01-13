#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

function getRating(report, selector) {
	for (let idx = 0; report.length > 1; ++idx) {
		let count = report.reduce((prev, curr) => {
			++prev[curr[idx]];
			return prev;
		}, [0, 0]);

		report = report.filter(el => el[idx] == selector(count));
	}

	return report[0].join("");
}

let report = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n")
	.map(el => el.split("").map(Number));

let oxygen = getRating(Array.from(report), ([zero, one]) => zero <= one ? 1 : 0);
let co2 = getRating(Array.from(report), ([zero, one]) => zero <= one ? 0 : 1);

console.log(parseInt(oxygen, 2) * parseInt(co2, 2));
