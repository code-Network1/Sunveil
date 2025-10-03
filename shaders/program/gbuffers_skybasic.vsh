#define GBUFFERS_SKYBASIC

#include "/shader.h"

varying float fogMix;
varying vec4 starColor;

#include "/math.glsl"
#include "/fog_and_atmosphere.glsl"

void main() {
   gl_Position = ftransform();

   fogMix = getFogMix(vec3(9999999999.0));
   starColor = vec4(
      random(gl_Vertex.xy) * gl_Color.rgb,
      float(gl_Color.r == gl_Color.g && gl_Color.g == gl_Color.b && gl_Color.r > 0.0)
   );
}
