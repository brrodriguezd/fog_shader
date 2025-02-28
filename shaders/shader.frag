precision mediump float;

varying vec2 vTexCoord;
varying float v_depth;

uniform sampler2D u_texture;
uniform vec4 u_fogColor;
uniform float u_fogNear;
uniform float u_fogFar;

void main() {
    vec4 color = texture2D(u_texture, vTexCoord);

    // Compute fog factor: 0 = no fog, 1 = full fog.
    float fogFactor = smoothstep(u_fogNear, u_fogFar, v_depth);

    // Mix the texture color with the fog color.
    gl_FragColor = mix(color, u_fogColor, fogFactor);
}
