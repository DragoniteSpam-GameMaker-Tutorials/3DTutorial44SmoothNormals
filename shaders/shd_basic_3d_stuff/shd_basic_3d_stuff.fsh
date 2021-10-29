varying vec2 v_vTexcoord;
varying vec4 v_vColour;

varying vec3 v_worldPosition;
varying vec3 v_worldNormal;

void main() {
    vec4 starting_color = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    
    vec4 lightAmbient = vec4(0.25, 0.25, 0.25, 1);
    vec3 lightDirection = normalize(vec3(1, 1, -1));
    
    float NdotL = max(0.0, -dot(v_worldNormal, lightDirection));
    
    vec4 final_color = starting_color * vec4(min(lightAmbient + NdotL, vec4(1)).rgb, starting_color.a);
    gl_FragColor = final_color;
}