#!/usr/bin/env node

import process from "process";
import * as fs from "fs";

function dfs(graph, seen, path, node) {
	if (node == "end") {
		++count;
		return;
	}

	let newSeen = [...seen];
	if (/^[a-z]+$/.test(node) && !newSeen.includes(node))
		newSeen.push(node);
	for (let next of graph[node]) {
		if (!newSeen.includes(next)) dfs(graph, newSeen, [...path, node], next);
	}
}

let graph = Object.create(null);

fs.readFileSync(process.argv[2], "utf8")
	.trim()
	.split("\n")
	.forEach(line => {
		function addEdge(from, to) {
			if (graph[from] == null) graph[from] = [to];
			else graph[from].push(to);
		}

		let [from, to] = line.split("-");
		addEdge(from, to);
		addEdge(to, from);
	});

let seen = [], path = [], count = 0;

dfs(graph, seen, path, "start");
console.log(count);
