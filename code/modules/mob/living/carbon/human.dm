/obj/mob/living/carbon/human
    // Add has_nose property
    var/has_nose = TRUE

    // Add nose component
    var/nose = null

    New()
        nose = new /obj/item/nose
        nose.loc = usr