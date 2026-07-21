// Updated to include the new antagonist's role and objectives
#include "antagonist_spawn.dm"

obj/antagonist/role = obj/antagonist
    // Existing role code...

    // Add new antagonist role
    obj/antagonist/role/saboteur = obj/antagonist/role
        name = "Saboteur"
        desc = "A master of deception and sabotage"
        objectives = list(
            "Disrupt station operations through sabotage",
            "Create confusion through deception",
            "Avoid detection while achieving goals"
        )