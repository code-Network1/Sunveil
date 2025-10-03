// =============================================================================
// FOG AND ATMOSPHERE FUNCTIONS
// Combined fog color and fog mixing calculations
// =============================================================================

uniform vec3 fogColor;
uniform vec3 skyColor;
uniform float fogEnd, fogStart;
uniform float near, far;
uniform int fogShape;

// Fog color calculation based on sky and position
vec3 getFogColor(float fogMix, vec3 feetPos) {
   return mix(fogColor, skyColor, fogMix * clamp(0.006*feetPos.y, 0.0, 1.0));
}

// Fog mixing calculation for different rendering conditions
float getFogMix(vec3 feetPos) {
   #ifndef ENABLE_FOG

      return 0.0;

   #endif

   float len = fogShape == 1 ? max(length(feetPos.xz), abs(feetPos.y)) : length(feetPos);

   #if MC_VERSION >= 11700

      if (fogEnd < far) {
         return rescale(len, min(fogStart, fogEnd), fogEnd);
      }

      #if defined GBUFFERS_SKYBASIC

         return 0.0;

      #elif defined GBUFFERS_CLOUDS

         return clamp((len - far) * (near * 0.01), 0.0, 1.0);

      #elif defined OVERWORLD

         float x = worldTime * NORMALIZE_TIME;

         x = clamp(25.0*(x < MIDNIGHT ? SUNSET - x : x - SUNRISE) + 0.3,
                  OVERWORLD_FOG_MIN,
                  OVERWORLD_FOG_MAX);

         x = min(x, 1.0 - rainStrength);

         return min(1.0, rescale(len, 0.9*x*far, far) + 0.0015*max(0.0, len - 96.0));

      #else

         return rescale(len, 0.9*far, far);

      #endif

   #else

      gl_FogFragCoord = len;

      return (isEyeInWater > 0) ? clamp(gl_FogFragCoord * 0.01, 0.0, 0.3)
                                : clamp((gl_FogFragCoord - gl_Fog.start) * gl_Fog.scale, 0.0, 1.0);

   #endif
}
