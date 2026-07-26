// Sample .dm file with style issues — before formatting
// This file has trailing whitespace and tab indentation that dmlint --fix will clean up

/proc/example_proc()
    var/name = "world"
    var/count = 42

    if(count > 0)
        return "hello [name]"
    else
        return "goodbye"

/obj/item/example
    name = "Example Item"
    desc = "A sample item for testing dmlint formatting."

/obj/item/example/proc/do_thing()
    set waitfor = FALSE
    . = ..()
    if(.)
        src.say("Done!")
    return .
