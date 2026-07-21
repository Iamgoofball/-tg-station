// Modified to include spawn conditions for the new antagonist
#include "antagonist_interactions.dm"

obj/antagonist/spawn = obj/antagonist
    // Existing spawn code...

    // Add spawn conditions for new antagonist
    proc/CanSpawnNewAntagonist()
        // Implement spawn conditions here
        return world.GetPlayerCount() > 10 && rand(100) < 20

    proc/SpawnNewAntagonist()
        if (.CanSpawnNewAntagonist())
            var/antagonist = new obj/antagonist/new_antagonist
            antagonist.MoveToRandomLocation()
            world << "<span class='danger'>A new threat has appeared on the station!</span>"