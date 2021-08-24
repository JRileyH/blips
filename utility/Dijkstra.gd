extends Resource
class_name Dijkstra

static func shortest_path(map: Array, src: Area2D, trg: Area2D):
	if not src in map or not trg in map:
		push_error("Source or target bloids %s, %s not in map %s" % [src, trg, map])
		return []

	var bloids: Array = []
	var cost: Dictionary = {}
	var path: Dictionary = {}
	
	for bloid in map:
		cost[bloid] = INF
		bloids.append(bloid)
	cost[src] = 0

	while bloids.size() > 0:
		var node: Area2D
		for bloid in bloids:
			if not node or cost[bloid] < cost[node]:
				node = bloid
		if node == trg:
			break
		bloids.erase(node)
		for neighbor in node.neighbors:
			if not neighbor in bloids:
				continue
			var distance: float = cost[node] + node.distance_to(neighbor)
			if distance < cost[neighbor]:
				cost[neighbor] = distance
				path[neighbor] = node
	var out: Array = []
	var next: Area2D = trg
	while next and next != src and next in path:
		out.push_front(next)
		next = path[next]
		
	return out
