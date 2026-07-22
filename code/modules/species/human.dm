/obj/mob/living/carbon/human
    organs = list()
    organs["brain"] = new /obj/item/organ/brain

    proc/Initialize()
        for(var/organ in organs)
            organ.Initialize(us)

    proc/Update()
        for(var/organ in organs)
            organ.Update()

    proc/GetOrgan(name)
        return organs[name]

    proc/ReceiveOxygen(amount)
        for(var/organ in organs)
            organ.ReceiveOxygen(amount)