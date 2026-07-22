/proc/surgery/PerformBrainSurgery(target, surgeon)
    if(!target || !surgeon)
        return

    var/brain = target.mob.GetOrgan("brain")
    if(!brain)
        return

    // Perform surgery logic here
    // This would include removing the brain, replacing it, etc.
    // For now, we'll just demonstrate the basic structure

    if(brain.IsConscious())
        surgeon << "The patient's brain is still conscious."
    else
        surgeon << "The patient's brain is not conscious."

    // Example of reviving the brain
    if(!brain.IsConscious())
        brain.Revive()
        surgeon << "You successfully revive the patient's brain."