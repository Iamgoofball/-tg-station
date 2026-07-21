/obj/effect/visual/insect
    name = "Insect Visual"
    desc = "Visual effect for transformed players."

    var/mob/living/mob = null

    Initialize(mob/living)
        mob = mob
        UpdateAppearance()

    UpdateAppearance()
        if (!mob)
            return

        // Change appearance to insect
        mob.icon = 'icons/mob/insect.dmi'
        mob.icon_state = "insect"
        mob.color = "#8B4513" // Brown color

        // Add insect-specific overlays
        mob.AddOverlay("insect_legs", "icons/mob/insect.dmi", "legs")
        mob.AddOverlay("insect_antennae", "icons/mob/insect.dmi", "antennae")

    Destroy()
        if (!mob)
            return

        // Revert appearance
        mob.icon = mob.original_icon
        mob.icon_state = mob.original_icon_state
        mob.color = mob.original_color

        // Remove insect-specific overlays
        mob.RemoveOverlay("insect_legs")
        mob.RemoveOverlay("insect_antennae")