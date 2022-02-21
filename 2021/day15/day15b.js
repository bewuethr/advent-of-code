#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

function getNext(g) {
	let minDist = Infinity;
	let minX, minY;

	for (let y = 0; y < g.length; ++y) {
		for (let x = 0; x < g[y].length; ++x) {
			if (g[y][x].visited) continue;
			if (g[y][x].dist < minDist) {
				minDist = g[y][x].dist;
				minX = x;
				minY = y;
			}
		}
	}

	return [minX, minY];
}

function incr(arr) {
	return arr.map(n => n == 9 ? 1 : n + 1);
}

let graph = fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n")
	.map(l => l.split("").map(Number))
	.map(arr => {
		let l = arr.length;
		for (let i = 0; i < 4; ++i) {
			arr.push(...incr(arr.slice(i * l)));
		}
		return arr;
	});

let rows = graph.length;
for (let i = 0; i < 4; ++i) {
	for (let j = 0; j < rows; ++j) {
		graph.push(incr(graph[i * rows + j]));
	}
}

graph = graph.map(row => row.map(n => ({
	val: n,
	dist: Infinity,
	visited: false,
	prev: null
})));

let dest = {
	x: graph[0].length - 1,
	y: graph.length - 1
};

graph[0][0].dist = 0;

for (;;) {
	let [x, y] = getNext(graph);
	if (x == dest.x && y == dest.y) break;
	graph[y][x].visited = true;
	for (let [dx, dy] of [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
		let newY = y + dy, newX = x + dx;
		if (newY < 0 || newY > dest.y) continue;
		if (newX < 0 || newX > dest.x) continue;
		if (graph[newY][newX].visited) continue;

		let alt = graph[y][x].dist + graph[newY][newX].val;
		if (alt < graph[newY][newX].dist) {
			graph[newY][newX].dist = alt;
			graph[newY][newX].prev = [x, y];
		}

	}
}

let path = [];
let cur = dest;
let sum = 0;
for (;;) {
	if (cur.x == 0 && cur.y == 0) break;
	let node = graph[cur.y][cur.x];
	sum += node.val;
	path.push(node);
	cur = {
		x: node.prev[0],
		y: node.prev[1]
	};
}

console.log(sum);
