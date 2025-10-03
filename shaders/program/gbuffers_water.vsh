#include "/shader.h"

attribute vec4 mc_Entity;

uniform float frameTimeCounter;
uniform float rainStrength;
uniform int isEyeInWater;
uniform int worldTime;
uniform sampler2D lightmap;
uniform vec3 sunPosition;

varying float fogMix;
varying float reflectivity;
varying float torchStrength;
varying float waterTexStrength;
varying vec2 lightUV;
varying vec2 texUV;
varying vec3 feetPos;
varying vec3 gradientFogColor;
varying vec4 ambient;
varying vec4 color;
varying vec4 normal;

#include "/math.glsl"
#include "/transformations.glsl"
#include "/fog_and_atmosphere.glsl"
#include "/lighting.glsl"
#include "/water_and_reflections.glsl"

// نظام الظلال الديناميكية
uniform vec3 shadowLightPosition;

void main() {
   gl_Position = ftransform();

   float sunHeight = view2feet(sunPosition).y;

   color        = gl_Color;
   texUV        = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
   lightUV      = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
   normal       = vec4(gl_Normal, 1.0);
   ambient      = getAmbientColor(sunHeight);
   reflectivity = GLASS_REFLECTIVITY;

   torchStrength = getTorchStrength(lightUV.s);
   feetPos = view2feet(getViewPosition());
   fogMix = getFogMix(feetPos);
   gradientFogColor = getFogColor(fogMix, feetPos);

   if (mc_Entity.x == 10008.0) {
      float posRandom = random(floor(feetPos.xz) + floor(cameraPosition.xz));

      #if WATER_WAVE_SIZE > 0

         if (abs(normal.y) > 0.8) {
            normal.xyz = normalize(normal.xyz + getWaterWave(posRandom, feetPos));
         }

      #endif

      reflectivity = WATER_REFLECTIVITY;
      waterTexStrength = getWaterTextureStrength(posRandom);
   }
}
