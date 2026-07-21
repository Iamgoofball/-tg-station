/obj/atmospherics/quadtree
    var/root = null
    var/max_depth = 8
    var/threshold = 10

    New(root, max_depth, threshold)
        . = ..()
        root = root
        max_depth = max_depth
        threshold = threshold

    proc/Insert(node, x, y, value)
        if(!node)
            return NewNode(x, y, value)

        if(node.depth >= max_depth || node.count < threshold)
            node.values = list(value)
            return node

        var index = GetIndex(node, x, y)
        node.children[index] = Insert(node.children[index], x, y, value)
        node.count++
        return node

    proc/GetIndex(node, x, y)
        var index = 0
        if(x >= node.x + node.size/2)
            index += 1
        if(y >= node.y + node.size/2)
            index += 2
        return index

    proc/NewNode(x, y, value)
        var node = new
        node.x = x
        node.y = y
        node.size = 1
        node.depth = 0
        node.count = 1
        node.values = list(value)
        node.children = list(null, null, null, null)
        return node

    proc/QueryRange(node, range, found)
        if(!node || !range.Intersects(Rect(node.x, node.y, node.size, node.size)))
            return

        if(node.values)
            for(var value in node.values)
                if(range.Contains(value.x, value.y))
                    found.Add(value)

        for(var child in node.children)
            QueryRange(child, range, found)