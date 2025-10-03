#version 120

#define THE_NETHER

uniform sampler2D texture;

varying vec2 texUV;
varying float alpha;

void main() {
   vec4 color = texture2D(texture, texUV);
   color.a *= alpha;
   
   if (color.a < 0.1) {
      discard;
   }
   
   gl_FragColor = color;
}