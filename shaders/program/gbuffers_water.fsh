#include "/shader.h"

uniform ivec2 eyeBrightnessSmooth;
uniform int isEyeInWater;
uniform sampler2D texture;

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

#ifdef HAND_DYNAMIC_LIGHTING
   uniform int heldBlockLightValue;
#endif

#include "/math.glsl"
#include "/lighting.glsl"

void main() {
   vec4 albedo  = texture2D(texture, texUV);
   vec4 ambient = ambient;
   vec4 color   = color;

   if (reflectivity > WATER_REFLECTIVITY - 0.01) {
      #if MC_VERSION >= 11300
         albedo.rgb = vec3(WATER_BRIGHTNESS * max(vec3(1.0), contrast(albedo.rgb, 3.2*waterTexStrength)));

         #define WATER_BUFFER color
      #else
         #define WATER_BUFFER albedo
      #endif

      WATER_BUFFER.ba = min(WATER_BUFFER.ba, vec2(max(WATER_BUFFER.r, WATER_BUFFER.g)*WATER_B, WATER_A));
   }

   ambient.rgb += 0.5*getTorchColor(ambient.rgb, feetPos);

   albedo *= color * ambient;

   albedo.rgb = mix(albedo.rgb, gradientFogColor, fogMix);

   /* DRAWBUFFERS:06 */
   gl_FragData[0] = albedo;
   
   // حساب المسافة من سطح الماء للتحكم في الانعكاسات
   float distanceFromSurface = isEyeInWater > 0 ? abs(feetPos.y) : 0.0;
   float reflectionFactor = isEyeInWater > 0 ? 
                           mix(MIN_REFLECTIVITY, reflectivity * 0.4, clamp(distanceFromSurface / 3.0, 0.0, 1.0)) :
                           reflectivity;
   
   gl_FragData[1] = vec4(sphericalEncode(normal.xyz), 
                        reflectionFactor * step(fogMix, 0.999), 
                        1.0);
}
