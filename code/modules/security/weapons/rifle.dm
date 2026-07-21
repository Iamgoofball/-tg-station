/obj/item/weapon/gun/rifle
    name = "rifle"
    desc = "A standard-issue rifle used by security officers."
    icon = 'icons/obj/items_and_weapons.dmi'
    icon_state = "rifle"
    ammo_type = /obj/item/ammo/bullet
    ammo_capacity = 30
    fire_rate = 1
    damage = 25
    accuracy = 75
    throwforce = 0
    throw_speed = 3
    throw_range = 5

    proc/attack()
        src = usr
        if(!src)
            return
        if(!src.ammo || src.ammo.type != ammo_type)
            src << "You don't have any ammo for the rifle."
            return
        src.ammo.amount--
        src << "You fire the rifle."
        src.damage = damage
        src.accuracy = accuracy
        src.throwforce = throwforce
        src.throw_speed = throw_speed
        src.throw_range = throw_range