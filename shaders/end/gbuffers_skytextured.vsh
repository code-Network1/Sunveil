#version 120

#define THE_END

#include "/shader.h"

varying vec2 texUV;
varying vec3 feetPos;
varying vec4 color;

#include "/math.glsl"
#include "/transformations.glsl"
#include "/lighting.glsl"

// Define shadowLightPosition to avoid compilation errors
uniform vec3 shadowLightPosition;

void main() {
   gl_Position = ftransform();

   color = gl_Color;
   texUV = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;

   feetPos = view2feet(getViewPosition());
   feetPos.y += END_STARS_FLOOR;
}
