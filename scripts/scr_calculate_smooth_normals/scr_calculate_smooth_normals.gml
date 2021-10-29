function scr_calculate_smooth_normals(vbuffer, threshold) {
    var buffer = buffer_create_from_vertex_buffer(vbuffer, buffer_fixed, 1);
    vertex_delete_buffer(vbuffer);
    
    var normal_cache = ds_map_create();
    
    for (var i = 0; i < buffer_get_size(buffer); i += 36 * 3) {
        var x1 = buffer_peek(buffer, i + 00, buffer_f32);
        var y1 = buffer_peek(buffer, i + 04, buffer_f32);
        var z1 = buffer_peek(buffer, i + 08, buffer_f32);
        
        var x2 = buffer_peek(buffer, i + 36, buffer_f32);
        var y2 = buffer_peek(buffer, i + 40, buffer_f32);
        var z2 = buffer_peek(buffer, i + 44, buffer_f32);
        
        var x3 = buffer_peek(buffer, i + 72, buffer_f32);
        var y3 = buffer_peek(buffer, i + 76, buffer_f32);
        var z3 = buffer_peek(buffer, i + 80, buffer_f32);
        
        var v1 = new Vector3(x1, y1, z1);
        var v2 = new Vector3(x2, y2, z2);
        var v3 = new Vector3(x3, y3, z3);
        
        var e1 = v2.Sub(v1);
        var e2 = v3.Sub(v1);
        
        // Calculate the flat normals for each triangle, as before
        var norm = e1.Cross(e2).Normalize();
        
        // Keep the flat normals in the vertex buffer; we'll need
        // them later to decide if a vertex should be smoothed or not
        buffer_poke(buffer, i + 12, buffer_f32, norm.x);
        buffer_poke(buffer, i + 16, buffer_f32, norm.y);
        buffer_poke(buffer, i + 20, buffer_f32, norm.z);
        
        buffer_poke(buffer, i + 48, buffer_f32, norm.x);
        buffer_poke(buffer, i + 52, buffer_f32, norm.y);
        buffer_poke(buffer, i + 56, buffer_f32, norm.z);
        
        buffer_poke(buffer, i + 84, buffer_f32, norm.x);
        buffer_poke(buffer, i + 88, buffer_f32, norm.y);
        buffer_poke(buffer, i + 92, buffer_f32, norm.z);
        
        // Generate a unique identifier for each vertex
        var v1_key = string(x1) + "," + string(y1) + "," + string(z1);
        var v2_key = string(x2) + "," + string(y2) + "," + string(z2);
        var v3_key = string(x3) + "," + string(y3) + "," + string(z3);
        
        // If each vertex does not have a cached normal yet, cache
        // the normal we just calculated; otherwise, add the normal
        // we just calculated to whatever's already there
        if (!ds_map_exists(normal_cache, v1_key)) {
            normal_cache[? v1_key] = norm;
        } else {
            normal_cache[? v1_key] = normal_cache[? v1_key].Add(norm);
        }
        
        if (!ds_map_exists(normal_cache, v2_key)) {
            normal_cache[? v2_key] = norm;
        } else {
            normal_cache[? v2_key] = normal_cache[? v2_key].Add(norm);
        }
        
        if (!ds_map_exists(normal_cache, v3_key)) {
            normal_cache[? v3_key] = norm;
        } else {
            normal_cache[? v3_key] = normal_cache[? v3_key].Add(norm);
        }
    }
    
    for (var i = 0; i < buffer_get_size(buffer); i += 36) {
        var xx = buffer_peek(buffer, i + 00, buffer_f32);
        var yy = buffer_peek(buffer, i + 04, buffer_f32);
        var zz = buffer_peek(buffer, i + 08, buffer_f32);
        var nx = buffer_peek(buffer, i + 12, buffer_f32);
        var ny = buffer_peek(buffer, i + 16, buffer_f32);
        var nz = buffer_peek(buffer, i + 20, buffer_f32);
        
        // Iterating over each vertex in the mesh a second time,
        // look the vertex up in the cache and normalize the result
        var vertex_key = string(xx) + "," + string(yy) + "," + string(zz);
        var existing_normal = new Vector3(nx, ny, nz);
        var norm = normal_cache[? vertex_key].Normalize();
        
        // If the smoothed normal is similar enough to the
        // vertex's flat normal, assign the smoothed normal
        // to it; otherwise, leave it alone
        if (existing_normal.Dot(norm) > threshold) {
            buffer_poke(buffer, i + 12, buffer_f32, norm.x);
            buffer_poke(buffer, i + 16, buffer_f32, norm.y);
            buffer_poke(buffer, i + 20, buffer_f32, norm.z);
        }
        
        // Note: there may other ways you may wish to decide
        // if a normal should be smoothed or not, depending on
        // the specifics of what you're trying to do
    }
    
    var updated_vertex_buffer = vertex_create_buffer_from_buffer(buffer, Camera.vertex_format);
    
    buffer_delete(buffer);
    ds_map_destroy(normal_cache);
    
    return updated_vertex_buffer;
}