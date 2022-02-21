#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

const literal = 4;

function parseValue(bits) {
	let idx = 0;
	let numStr = "";

	do {
		numStr += bits.slice(idx + 1, idx + 5);
		idx += 5;
	} while (bits[idx - 5] == 1);

	return [parseInt(numStr, 2), idx];
}

function parsePacket(bits) {
	let ptr = 0;
	let version = parseInt(bits.slice(ptr, ptr + 3), 2);
	sum += version;
	ptr += 3;
	let typeID = parseInt(bits.slice(ptr, ptr + 3), 2);
	ptr += 3;

	if (typeID == literal) {
		let [value, len] = parseValue(bits.slice(ptr));
		return [{version, typeID, value}, len + 6];
	}

	// Operator packet
	let lenTypeID = Number(bits.slice(ptr, ptr + 1));
	++ptr;

	if (lenTypeID === 0) {
		// Next 15 bits are length of subpackets
		let subPacketLen = parseInt(bits.slice(ptr, ptr + 15), 2);
		ptr += 15;
		let subIdx = 0;
		let subPackets = [];
		while (subIdx < subPacketLen) {
			let [subPacket, subLen] = parsePacket(bits.slice(ptr + subIdx));
			subPackets.push(subPacket);
			subIdx += subLen;
		}

		return [{version, typeID, subPackets}, ptr + subPacketLen];
	}

	// Next 11 bits are number of subpackets
	let nSubPackets = parseInt(bits.slice(ptr, ptr + 11), 2);
	ptr += 11;

	let subIdx = 0;
	let subPackets = [];
	for (let i = 0; i < nSubPackets; ++i) {
		let [subPacket, subLen] = parsePacket(bits.slice(ptr + subIdx));
		subPackets.push(subPacket);
		subIdx += subLen;
	}

	return [{version, typeID, subPackets}, ptr + subIdx];
}

let input = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("")
	.map(c => parseInt(c, 16).toString(2).padStart(4, "0"))
	.join("");

let sum = 0;
parsePacket(input);
console.log(sum);
