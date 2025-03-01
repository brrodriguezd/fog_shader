let fogShader;
let textureImg;
let cubes = [];
let fogColor = [0.8, 0.9, 1, 1];
let fogNear = 700.0;
let fogFar = 700.0;
let numCubes = 40;

// Declarar los sliders y etiquetas
let fogNearSlider, fogFarSlider;
let fogNearLabel, fogFarLabel;

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

  // Crear sliders y etiquetas
  fogNearSlider = createSlider(0, 1000, fogNear, 1);
  fogNearSlider.position(10, height + 10);
  fogNearLabel = createDiv(`fog near: ${fogNear}`);
  fogNearLabel.position(200, height + 10);
  
  fogFarSlider = createSlider(0, 1000, fogFar, 1);
  fogFarSlider.position(10, height + 40);
  fogFarLabel = createDiv(`fog far: ${fogFar}`);
  fogFarLabel.position(200, height + 40);
}

function draw() {
  background(204, 229, 255);

  // Actualizar los valores de fogNear y fogFar con los valores de los sliders
  fogNear = fogNearSlider.value();
  fogFar = fogFarSlider.value();

  // Actualizar las etiquetas con los valores actuales
  fogNearLabel.html(`fog near: ${fogNear}`);
  fogFarLabel.html(`fog far: ${fogFar}`);

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
