#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

const totLen = 0;

const [sumID, prodID, minID, maxID, litID, gtID, ltID, eqID] = [...Array(8).keys()];


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
	ptr += 3;
	let typeID = parseInt(bits.slice(ptr, ptr + 3), 2);
	ptr += 3;

	let packet = {}, ptrDiff;

	if (typeID == litID) {
		let [value, len] = parseValue(bits.slice(ptr));
		packet = {version, typeID, value};
		ptrDiff = len + 6;
	}
	else {
		// Operator packet
		let lenTypeID = Number(bits.slice(ptr, ptr + 1));
		++ptr;

		if (lenTypeID === totLen) {
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

			packet = {version, typeID, subPackets};
			ptrDiff = ptr + subPacketLen;
		}
		else {
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

			packet = {version, typeID, subPackets};
			ptrDiff = ptr + subIdx;
		}
	}

	switch (typeID) {
		case sumID:
			packet.value = packet.subPackets.reduce((sum, cur) => sum + cur.value, 0);
			break;

		case prodID:
			packet.value = packet.subPackets.reduce((prod, cur) => prod * cur.value, 1);
			break;

		case minID:
			packet.value = packet.subPackets.reduce((min, cur) =>
				min < cur.value ? min : cur.value, Infinity);
			break;

		case maxID:
			packet.value = packet.subPackets.reduce((max, cur) =>
				max > cur.value ? max : cur.value, 0);
			break;

		case gtID: {
			let [sp0, sp1] = packet.subPackets;
			packet.value = sp0.value > sp1.value ? 1 : 0;
			break;
		}

		case ltID: {
			let [sp0, sp1] = packet.subPackets;
			packet.value = sp0.value < sp1.value ? 1 : 0;
			break;
		}

		case eqID: {
			let [sp0, sp1] = packet.subPackets;
			packet.value = sp0.value == sp1.value ? 1 : 0;
			break;
		}
	}

	return [packet, ptrDiff];
}

let input = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("")
	.map(c => parseInt(c, 16).toString(2).padStart(4, "0"))
	.join("");

let [packet] = parsePacket(input);
console.log(packet.value);
