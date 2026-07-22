/proc/medical/health_analyzer/ScanBrain(target, user)
    if(!target || !user)
        return

    var/brain = target.mob.GetOrgan("brain")
    if(!brain)
        user << "No brain detected."
        return

    var/oxygen_level = brain.oxygen_level
    var/conscious = brain.IsConscious()

    user << "Brain Status:"
    user << "Oxygen Level: " + oxygen_level + "%"
    user << "Conscious: " + (conscious ? "Yes" : "No")