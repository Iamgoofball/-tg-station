/obj/item/equipment/security
    name = "security equipment"
    desc = "Various equipment used by security officers."
    icon = 'icons/obj/items_and_weapons.dmi'
    icon_state = "equipment"

    proc/init()
        src = usr
        if(!src)
            return
        src << "You have equipped security equipment."
        src.armor = /obj/item/clothing/armor/security
        src.weapon = /obj/item/weapon/melee/baton
        src.sidearm = /obj/item/weapon/gun/rifle