/obj/item/organ
    name = "organ"
    desc = "A vital organ."
    icon = 'icons/obj/surgery/organ.dmi'
    icon_state = "organ"

    var/owner = null

    proc/Initialize(owner_obj)
        owner = owner_obj

    proc/Update()
        // To be overridden by child classes

    proc/ReceiveOxygen(amount)
        // To be overridden by child classes

    proc/IsConscious()
        // To be overridden by child classes
        return 1

    proc/Revive()
        // To be overridden by child classes