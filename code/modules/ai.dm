/obj/mob/living/carbon/human/ai
    // Modify AI interactions to reflect the absence of cloning
    proc/Initialize()
        ..()
        if (world)
            del(self.cloning)

    // Update AI procedures to exclude cloning options
    proc/SetupAI()
        ..()
        if (world)
            del(self.cloning)

[FILE: code/modules/verbs.dm]