/proc/GetAtmosphericNode(x, y)
    var found = list()
    world.quadtree.QueryRange(Rect(x, y, 1, 1), found)
    if(found)
        return found[0]
    return null

/proc/UpdateAtmosphericNode(node, new_values)
    node.values = new_values