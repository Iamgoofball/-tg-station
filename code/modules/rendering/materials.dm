/material/pbr_material
    base_material = null
    albedo_color = null
    metallic = 0
    roughness = 0.5
    normal_map = null
    ao_map = null

/material/pbr_material/New(base_material, albedo_color, metallic, roughness, normal_map, ao_map)
    . = new()
    ..base_material = base_material
    ..albedo_color = albedo_color
    ..metallic = metallic
    ..roughness = roughness
    ..normal_map = normal_map
    ..ao_map = ao_map

/material/pbr_material/Apply()
    if(!.base_material)
        return

    .base_material.Apply()

    if(.albedo_color)
        set_albedo_color(.albedo_color)

    if(.normal_map)
        set_normal_map(.normal_map)

    if(.ao_map)
        set_ao_map(.ao_map)

    set_metallic(.metallic)
    set_roughness(.roughness)

/proc/set_albedo_color(color)
    // Implementation for setting albedo color

/proc/set_normal_map(map)
    // Implementation for setting normal map

/proc/set_ao_map(map)
    // Implementation for setting ambient occlusion map

/proc/set_metallic(value)
    // Implementation for setting metallic value

/proc/set_roughness(value)
    // Implementation for setting roughness value