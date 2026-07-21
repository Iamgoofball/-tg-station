/obj/item/weapon/gun/shotgun
    name = "shotgun"
    desc = "A powerful shotgun used by security officers for close-range combat."
    icon = 'icons/obj/items_and_weapons.dmi'
    icon_state = "shotgun"
    ammo_type = /obj/item/ammo/shell
    ammo_capacity = 8
    fire_rate = 1
    damage = 40
    accuracy = 60
    spread = 30
    throwforce = 0
    throw_speed = 3
    throw_range = 5

    proc/attack()
        src = usr
        if(!src)
            return
        if(!src.ammo || src.ammo.type != ammo_type)
            src << "You don't have any ammo for the shotgun."
            return
        src.ammo.amount--
        src << "You fire the shotgun."
        src.damage = damage
        src.accuracy = accuracy
        src.spread = spread
        src.throwforce = throwforce
        src.throw_speed = throw_speed
        src.throw_range = throw_range