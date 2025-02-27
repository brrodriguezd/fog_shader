PShader shader3D;
PShape cube;
PImage textureImg;

float fieldOfViewRadians;
float modelXRotation = 0;
float modelYRotation = 0;
float fogNear = 0.7;
float fogFar = 0.9;
float xOff = 1.1;
float zOff = 1.4;
int numCubes = 40;

float lastTime;

void setup() {
  // Puedes usar fullScreen(P3D) si deseas que ocupe toda la pantalla.
  size(800, 600, P3D);
  
  // --- Shader personalizado ---
  // Para Processing se usan atributos por defecto: "vertex" y "texcoord".
  // Se ha adaptado el código de los shaders para que coincida con las convenciones de Processing.
  String[] vertSource = {
    "#version 150",
    "in vec4 vertex;",          // posición (en lugar de a_position)
    "in vec2 texcoord;",        // coordenadas de textura (en lugar de a_texcoord)
    "uniform mat4 u_worldView;",
    "uniform mat4 u_projection;",
    "out vec2 v_texcoord;",
    "void main() {",
    "  gl_Position = u_projection * u_worldView * vertex;",
    "  v_texcoord = texcoord;",
    "}"
  };
  
  String[] fragSource = {
    "#version 150",
    "precision mediump float;",
    "in vec2 v_texcoord;",
    "uniform sampler2D u_texture;",
    "uniform vec4 u_fogColor;",
    "uniform float u_fogNear;",
    "uniform float u_fogFar;",
    "out vec4 fragColor;",
    "void main() {",
    "  vec4 color = texture(u_texture, v_texcoord);",
    "  float fogAmount = smoothstep(u_fogNear, u_fogFar, gl_FragCoord.z);",
    "  fragColor = mix(color, u_fogColor, fogAmount);",
    "}"
  };
  
  shader3D = new PShader(this, vertSource, fragSource);
  
  // --- Cargar la textura ---
  textureImg = loadImage("https://webglfundamentals.org/webgl/resources/f-texture.png");
  
  // --- Crear el PShape del cubo ---
  cube = createCubeShape();
  
  // --- Configurar cámara y proyección ---
  fieldOfViewRadians = radians(60);
  // La cámara se coloca en (0,0,2) mirando al origen con up (0,1,0)
  camera(0, 0, 2,  0, 0, 0,  0, 1, 0);
  
  // Inicia el tiempo
  lastTime = millis() / 1000.0;
  
  // Asocia el shader; luego lo actualizaremos con nuestras matrices
  shader(shader3D);
}

void draw() {
  float currentTime = millis() / 1000.0;
  float deltaTime = currentTime - lastTime;
  lastTime = currentTime;
  
  // Actualizar las rotaciones (animación similar al ejemplo original)
  modelYRotation += -0.7 * deltaTime;
  modelXRotation += -0.4 * deltaTime;
  
  // Usar el color de niebla para limpiar el fondo.
  // La niebla se define como [0.8, 0.9, 1, 1] (multiplicado por 255 → aproximadamente (204,229,255))
  background(204, 229, 255);
  
  // --- Actualizar las matrices del shader ---
  // Obtener la matriz de proyección del entorno P3D (del objeto g)
  PMatrix3D proj = ((PGraphics3D)g).projection.get();
  // Envío de u_projection (debe enviarse como arreglo de 16 floats)
  shader3D.set("u_projection", new float[] {
    proj.m00, proj.m01, proj.m02, proj.m03,
    proj.m10, proj.m11, proj.m12, proj.m13,
    proj.m20, proj.m21, proj.m22, proj.m23,
    proj.m30, proj.m31, proj.m32, proj.m33
  });
  
  // Enviar constantes para la niebla
  shader3D.set("u_fogColor", new float[] {0.8, 0.9, 1, 1});
  shader3D.set("u_fogNear", fogNear);
  shader3D.set("u_fogFar", fogFar);
  
  // Enlazar la textura (Processing la asigna automáticamente al uniform "u_texture")
  shader3D.set("u_texture", textureImg);
  
  // Para cada cubo se calcula la matriz "worldView"
  // Como Processing acumula la transformación en el modelo (ya incluye la cámara),
  // podemos obtener la matriz actual (modelo-vista) con getMatrix().
  for (int i = 0; i <= numCubes; i++) {
    pushMatrix();
      // Traslación: se mueve a (-2 + i*xOff, 0, -i*zOff)
      translate(-2 + i * xOff, 0, -i * zOff);
      // Rotaciones en X e Y
      rotateX(modelXRotation + i * 0.1);
      rotateY(modelYRotation + i * 0.1);
      
      // La matriz resultante es la combinación de la cámara y las transformaciones locales.
      PMatrix3D worldView = getMatrix(new PMatrix3D());
      shader3D.set("u_worldView", new float[] {
        worldView.m00, worldView.m01, worldView.m02, worldView.m03,
        worldView.m10, worldView.m11, worldView.m12, worldView.m13,
        worldView.m20, worldView.m21, worldView.m22, worldView.m23,
        worldView.m30, worldView.m31, worldView.m32, worldView.m33
      });
      
      // Dibujar el cubo
      shape(cube);
    popMatrix();
  }
}

// Función para construir el PShape que representa el cubo con 36 vértices y sus coordenadas de textura
PShape createCubeShape() {
  PShape sh = createShape();
  sh.beginShape(TRIANGLES);
  sh.texture(textureImg);
  // Se definen los vértices del cubo (mismo orden que en el ejemplo original)
  float[] pos = {
    -0.5, -0.5, -0.5,
    -0.5,  0.5, -0.5,
     0.5, -0.5, -0.5,
    -0.5,  0.5, -0.5,
     0.5,  0.5, -0.5,
     0.5, -0.5, -0.5,

    -0.5, -0.5,  0.5,
     0.5, -0.5,  0.5,
    -0.5,  0.5,  0.5,
    -0.5,  0.5,  0.5,
     0.5, -0.5,  0.5,
     0.5,  0.5,  0.5,

    -0.5,  0.5, -0.5,
    -0.5,  0.5,  0.5,
     0.5,  0.5, -0.5,
    -0.5,  0.5,  0.5,
     0.5,  0.5,  0.5,
     0.5,  0.5, -0.5,

    -0.5, -0.5, -0.5,
     0.5, -0.5, -0.5,
    -0.5, -0.5,  0.5,
    -0.5, -0.5,  0.5,
     0.5, -0.5, -0.5,
     0.5, -0.5,  0.5,

    -0.5, -0.5, -0.5,
    -0.5, -0.5,  0.5,
    -0.5,  0.5, -0.5,
    -0.5, -0.5,  0.5,
    -0.5,  0.5,  0.5,
    -0.5,  0.5, -0.5,

     0.5, -0.5, -0.5,
     0.5,  0.5, -0.5,
     0.5, -0.5,  0.5,
     0.5, -0.5,  0.5,
     0.5,  0.5, -0.5,
     0.5,  0.5,  0.5,
  };
  
  float[] tex = {
    0, 0,
    0, 1,
    1, 0,
    0, 1,
    1, 1,
    1, 0,
    
    0, 0,
    1, 0,
    0, 1,
    0, 1,
    1, 0,
    1, 1,
    
    0, 0,
    0, 1,
    1, 0,
    0, 1,
    1, 1,
    1, 0,
    
    0, 0,
    1, 0,
    0, 1,
    0, 1,
    1, 0,
    1, 1,
    
    0, 0,
    0, 1,
    1, 0,
    0, 1,
    1, 1,
    1, 0,
    
    0, 0,
    1, 0,
    0, 1,
    0, 1,
    1, 0,
    1, 1,
  };
  
  // Se agregan los 36 vértices con sus coordenadas de textura
  for (int i = 0; i < 36; i++) {
    int posIndex = i * 3;
    int texIndex = i * 2;
    float x = pos[posIndex];
    float y = pos[posIndex + 1];
    float z = pos[posIndex + 2];
    float u = tex[texIndex];
    float v = tex[texIndex + 1];
    sh.vertex(x, y, z, u, v);
  }
  
  sh.endShape();
  return sh;
}
