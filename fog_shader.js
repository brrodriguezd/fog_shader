let fogShader;
let textureImg;
let cubes = [];
let fogColor = [0.8, 0.9, 1, 1];
let fogNear = 300.0;
let fogFar = 700.0;
let numCubes = 40;

function preload() {
  textureImg = loadImage("https://webglfundamentals.org/webgl/resources/f-texture.png");
  fogShader = loadShader("./shaders/shader.vert", "./shaders/shader.frag");
}

function setup() {
  createCanvas(800, 600, WEBGL);
  noStroke();

  // Create a list of cubes arranged at different depths.
  for (let i = 0; i < numCubes; i++) {
    let x = random(-200, 200);
    let y = random(-200, 200);
    // Start at z = -50 and increase depth by 20 units per cube.
    let z = -50 - i * 20;
    cubes.push({ x, y, z });
  }
}

function draw() {
  background(204, 229, 255);

  shader(fogShader);

  // Set shader uniforms.
  fogShader.setUniform("u_texture", textureImg);
  fogShader.setUniform("u_fogColor", fogColor);
  fogShader.setUniform("u_fogNear", fogNear);
  fogShader.setUniform("u_fogFar", fogFar);

  rotateY(frameCount * 0.01);

  for (let cube of cubes) {
    push();
    translate(cube.x, cube.y, cube.z);
    box(50);
    pop();
  }
}
