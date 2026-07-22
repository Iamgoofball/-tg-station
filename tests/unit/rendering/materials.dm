/material/tests/PBRMaterialTests()
    var/test = newlist()

    test += new(/test/case
        name = "PBR Material Creation"
        run = proc()
            var/material = new(/material/pbr_material, null, "#ffffff", 0.5, 0.5, null, null)
            assert(material is /material/pbr_material)
            assert(material.albedo_color == "#ffffff")
            assert(material.metallic == 0.5)
            assert(material.roughness == 0.5)
    )

    return test