/species/shitman
    name = "shitman"
    id = "shitman"
    species_type = SPECIES_HUMANOID
    default_appearance = 'shitman
    mob_type = /mob/living/carbon/human
    mob_spawn_flags = MOB_SPAWN_HUMAN
    mob_spawn_proc = proc()
        ..()
        mob.message("You're now a shitmen!", mob)

    mob_death_proc = proc()
        ..()
        mob.message("You have been transformed into a shitman!", mob)