/obj/item/weapon/flashbang
    name = "flashbang grenade"
    desc = "A stun grenade that emits a blinding flash when detonated."
    icon = 'icons/obj/items_and_weapons.dmi'
    icon_state = "flashbang"
    effect_radius = 5
    effect_duration = 10
    throwforce = 5
    throw_speed = 3
    throw_range = 7

    proc/attack()
        src = usr
        if(!src)
            return
        src << "You pull the pin on the flashbang grenade."
        src.throwforce = throwforce
        src.throw_speed = throw_speed
        src.throw_range = throw_range
        src << "You throw the flashbang grenade."

    proc/effect()
        area = list()
        for(obj in world)
            if(obj.loc in src.loc && obj != src)
                area = area + obj
        for(obj in area)
            if(obj.is_mob && obj.can_be_seen(src))
                obj << "A blinding flash engulfs you!"
                obj.blind(effect_duration)