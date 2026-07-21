// Unit tests for the new antagonist
#include "new_antagonist.dm"

test("New antagonist initialization")
    var/antagonist = new obj/antagonist/new_antagonist
    assert(antagonist.name == "Saboteur")
    assert(antagonist.desc == "A master of deception and sabotage")
    assert(antagonist.icon_state == "saboteur")

test("Sabotage functionality")
    var/antagonist = new obj/antagonist/new_antagonist
    var/initial_systems = world.GetSystemCount()
    antagonist.Sabotage()
    assert(world.GetSystemCount() < initial_systems)

test("Deception activation")
    var/antagonist = new obj/antagonist/new_antagonist
    assert(!antagonist.deception_active)
    antagonist.ActivateDeception()
    assert(antagonist.deception_active)

test("Player interaction")
    var/antagonist = new obj/antagonist/new_antagonist
    var/crew = new obj/mob/living/human
    antagonist.HandleInteraction(crew)
    // Add assertions for expected interaction behavior