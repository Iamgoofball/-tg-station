/obj/chemical/oxygen
    name = "oxygen"
    desc = "A vital gas for sustaining life."
    icon = 'icons/obj/chemicals.dmi'
    icon_state = "oxygen"

    var/effect = "Provides oxygen to the body."

    proc/Use(target)
        if(!target)
            return

        var/brain = target.mob.GetOrgan("brain")
        if(brain)
            brain.ReceiveOxygen(20)