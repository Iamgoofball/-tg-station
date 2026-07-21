/obj/effect/xenobiology/crossbreed
    name = "crossbreed"
    desc = "A crossbreed of two slime colors"

    var/slime_color/color1
    var/slime_color/color2

    New(color1, color2)
        . = ..()
        color1 = color1
        color2 = color2
        name = "crossbreed of " + color1 + " and " + color2
        desc = "A crossbreed of " + color1 + " and " + color2 + " slime colors"

    ApplyEffect(mob/living/mob)
        // Apply the effects based on the crossbreed colors
        switch(color1)
            if(color1 == "charged green" && color2 == "carbon")
                mob.SpikyCarbons()
            else if(color1 == "bluespace" && color2 == "warping")
                mob.WarpingEffect()
            else if(color1 == "sepia" && color2 == "lengthened")
                mob.LengthenedEffect()
            else if(color1 == "pink" && color2 == "gentle")
                mob.GentleEffect()
            else if(color1 == "red" && color2 == "destabilized")
                mob.DestabilizedEffect()
            else if(color1 == "green" && color2 == "mutative")
                mob.MutativeEffect()
            else if(color1 == "gold" && color2 == "symbiot")
                mob.SymbiotEffect()
            else if(color1 == "oil" && color2 == "detonating")
                mob.DetonatingEffect()
            else if(color1 == "black" && color2 == "transformative")
                mob.TransformativeEffect()
            else if(color1 == "pink" && color2 == "loyal")
                mob.LoyalEffect()
            else if(color1 == "adamantine" && color2 == "crystalline")
                mob.CrystallineEffect()
            else if(color1 == "rainbow" && color2 == "hyperchromatic")
                mob.HyperchromaticEffect()

    SpikyCarbons(mob/living/mob)
        mob.SpikyCarbons = New(/obj/effect/xenobiology/spiky_carbons)
        mob.SpikyCarbons.ApplyEffect(mob)

    WarpingEffect(mob/living/mob)
        mob.WarpingEffect = New(/obj/effect/xenobiology/warping)
        mob.WarpingEffect.ApplyEffect(mob)

    LengthenedEffect(mob/living/mob)
        mob.LengthenedEffect = New(/obj/effect/xenobiology/lengthened)
        mob.LengthenedEffect.ApplyEffect(mob)

    GentleEffect(mob/living/mob)
        mob.GentleEffect = New(/obj/effect/xenobiology/gentle)
        mob.GentleEffect.ApplyEffect(mob)

    DestabilizedEffect(mob/living/mob)
        mob.DestabilizedEffect = New(/obj/effect/xenobiology/destabilized)
        mob.DestabilizedEffect.ApplyEffect(mob)

    MutativeEffect(mob/living/mob)
        mob.MutativeEffect = New(/obj/effect/xenobiology/mutative)
        mob.MutativeEffect.ApplyEffect(mob)

    SymbiotEffect(mob/living/mob)
        mob.SymbiotEffect = New(/obj/effect/xenobiology/symbiot)
        mob.SymbiotEffect.ApplyEffect(mob)

    DetonatingEffect(mob/living/mob)
        mob.DetonatingEffect = New(/obj/effect/xenobiology/detonating)
        mob.DetonatingEffect.ApplyEffect(mob)

    TransformativeEffect(mob/living/mob)
        mob.TransformativeEffect = New(/obj/effect/xenobiology/transformative)
        mob.TransformativeEffect.ApplyEffect(mob)

    LoyalEffect(mob/living/mob)
        mob.LoyalEffect = New(/obj/effect/xenobiology/loyal)
        mob.LoyalEffect.ApplyEffect(mob)

    CrystallineEffect(mob/living/mob)
        mob.CrystallineEffect = New(/obj/effect/xenobiology/crystalline)
        mob.CrystallineEffect.ApplyEffect(mob)

    HyperchromaticEffect(mob/living/mob)
        mob.HyperchromaticEffect = New(/obj/effect/xenobiology/hyperchromatic)
        mob.HyperchromaticEffect.ApplyEffect(mob)