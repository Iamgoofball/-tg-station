/slime_color/charged_green
    name = "charged green"
    desc = "A slime color that charges up and releases energy in a burst"

    CrossbreedWith(color)
        if(color == /slime_color/carbon)
            return New(/obj/effect/xenobiology/crossbreed, "charged green", "carbon")

/slime_color/bluespace
    name = "bluespace"
    desc = "A slime color that warps space around it"

    CrossbreedWith(color)
        if(color == /slime_color/warping)
            return New(/obj/effect/xenobiology/crossbreed, "bluespace", "warping")

/slime_color/sepia
    name = "sepia"
    desc = "A slime color that lengthens the effects of extracts"

    CrossbreedWith(color)
        if(color == /slime_color/lengthened)
            return New(/obj/effect/xenobiology/crossbreed, "sepia", "lengthened")

/slime_color/pink
    name = "pink"
    desc = "A slime color that has a gentle luminescent effect"

    CrossbreedWith(color)
        if(color == /slime_color/gentle)
            return New(/obj/effect/xenobiology/crossbreed, "pink", "gentle")
        else if(color == /slime_color/loyal)
            return New(/obj/effect/xenobiology/crossbreed, "pink", "loyal")

/slime_color/red
    name = "red"
    desc = "A slime color that destabilizes things around it"

    CrossbreedWith(color)
        if(color == /slime_color/destabilized)
            return New(/obj/effect/xenobiology/crossbreed, "red", "destabilized")

/slime_color/green
    name = "green"
    desc = "A slime color that mutates things around it"

    CrossbreedWith(color)
        if(color == /slime_color/mutative)
            return New(/obj/effect/xenobiology/crossbreed, "green", "mutative")

/slime_color/gold
    name = "gold"
    desc = "A slime color that forms symbiotic organs"

    CrossbreedWith(color)
        if(color == /slime_color/symbiot)
            return New(/obj/effect/xenobiology/crossbreed, "gold", "symbiot")

/slime_color/oil
    name = "oil"
    desc = "A slime color that detonates in a burst of energy"

    CrossbreedWith(color)
        if(color == /slime_color/detonating)
            return New(/obj/effect/xenobiology/crossbreed, "oil", "detonating")

/slime_color/black
    name = "black"
    desc = "A slime color that transforms objects around it"

    CrossbreedWith(color)
        if(color == /slime_color/transformative)
            return New(/obj/effect/xenobiology/crossbreed, "black", "transformative")

/slime_color/adamantine
    name = "adamantine"
    desc = "A slime color that forms crystalline structures"

    CrossbreedWith(color)
        if(color == /slime_color/crystalline)
            return New(/obj/effect/xenobiology/crossbreed, "adamantine", "crystalline")

/slime_color/rainbow
    name = "rainbow"
    desc = "A slime color that leverages emergent technology"

    CrossbreedWith(color)
        if(color == /slime_color/hyperchromatic)
            return New(/obj/effect/xenobiology/crossbreed, "rainbow", "hyperchromatic")