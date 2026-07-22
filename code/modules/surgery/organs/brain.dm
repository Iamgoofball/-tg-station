/obj/item/organ/brain
    name = "brain"
    desc = "A vital organ responsible for consciousness and higher brain functions."
    icon = 'icons/obj/surgery/organ.dmi'
    icon_state = "brain"

    var/oxygen_level = 100
    var/conscious = 1

    proc/Update()
        if(oxygen_level <= 0)
            conscious = 0
            owner.mob.life.Update()
        else if(oxygen_level < 20)
            owner.mob.life.Update()
        oxygen_level = max(0, oxygen_level - 0.1)

    proc/ReceiveOxygen(amount)
        oxygen_level = min(100, oxygen_level + amount)

    proc/IsConscious()
        return conscious

    proc/Revive()
        oxygen_level = 100
        conscious = 1
        owner.mob.life.Update()

/obj/item/organ/brain/Update()
    . = src
    oxygen_level = 100
    conscious = 1

/obj/item/organ/brain/ReceiveOxygen(amount)
    . = src
    oxygen_level = min(100, oxygen_level + amount)

/obj/item/organ/brain/IsConscious()
    . = src
    return conscious

/obj/item/organ/brain/Revive()
    . = src
    oxygen_level = 100
    conscious = 1
    owner.mob.life.Update()