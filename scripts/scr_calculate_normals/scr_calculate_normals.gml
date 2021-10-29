function scr_calculate_normals(vbuffer) {
    var buffer = buffer_create_from_vertex_buffer(vbuffer, buffer_fixed, 1);
    vertex_delete_buffer(vbuffer);
    
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
        
        var norm = e1.Cross(e2).Normalize();
        
        buffer_poke(buffer, i + 12, buffer_f32, norm.x);
        buffer_poke(buffer, i + 16, buffer_f32, norm.y);
        buffer_poke(buffer, i + 20, buffer_f32, norm.z);
        
        buffer_poke(buffer, i + 48, buffer_f32, norm.x);
        buffer_poke(buffer, i + 52, buffer_f32, norm.y);
        buffer_poke(buffer, i + 56, buffer_f32, norm.z);
        
        buffer_poke(buffer, i + 84, buffer_f32, norm.x);
        buffer_poke(buffer, i + 88, buffer_f32, norm.y);
        buffer_poke(buffer, i + 92, buffer_f32, norm.z);
    }
    
    var updated_vertex_buffer = vertex_create_buffer_from_buffer(buffer, Camera.vertex_format);
    
    buffer_delete(buffer);
    
    return updated_vertex_buffer;
}