precision mediump float;

// p5.js provides these attributes automatically.
attribute vec3 aPosition;
attribute vec2 aTexCoord;

// p5.js supplies these uniform matrices.
uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;

varying vec2 vTexCoord;
varying float v_depth;

void main() {
    // Transform the vertex into view space.
    vec4 mvPosition = uModelViewMatrix * vec4(aPosition, 1.0);
    gl_Position = uProjectionMatrix * mvPosition;

    // Pass through texture coordinates.
    vTexCoord = aTexCoord;

    // Compute the positive view-space depth.
    v_depth = -mvPosition.z;
}
