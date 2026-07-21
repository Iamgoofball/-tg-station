// Add kirkification to the transformation procedures
proc/kirkify(obj)
    if(!obj)
        return

    obj.name = "Kirkified " + obj.name
    obj.desc = "This object has been transformed into a Kirk-like item."
    obj.icon_state = "kirkified_" + obj.icon_state