// Modified to include the new antagonist in the antagonist selection system
#include "antagonist_roles.dm"

obj/antagonist = obj/mob/living/carbon/human
    // Existing antagonist code...

    // Add new antagonist to the selection system
    proc/GetAntagonistList()
        return list(
            // Existing antagonists...
            obj/antagonist/new_antagonist
        )