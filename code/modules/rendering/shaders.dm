/shader/pbr_shader
    shader_path = "/shaders/pbr.hlsl"
    normal_shader_path = "/shaders/pbr_normal.hlsl"

    New()
        . = new()

    Apply()
        if(has_normal_map())
            set_shader(normal_shader_path)
        else
            set_shader(shader_path)

    has_normal_map()
        // Check if normal map is set