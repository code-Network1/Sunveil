// =============================================================================
// WATER AND REFLECTIONS FUNCTIONS
// Combined water wave, reflections, and block reflectivity data
// =============================================================================

// Block reflectivity data array
// x = reflectivity (0-0.99), 0-0.5 are pixelated reflections and 0.5-0.99 are mirror-like reflections
// y = reflection min luma (0-0.99)
// z = reflection max luma (0-0.99)
const vec3 BLOCK_REFLECTIVITY[19] = vec3[](
   vec3(0.0),              // default
   vec3(0.15, 0.05, 0.40), // cauldron and anvil
   vec3(0.15, 0.08, 0.40), // deepslate tiles
   vec3(0.15, 0.10, 0.55), // deepslate bricks
   vec3(0.15, 0.25, 0.60), // polished tuff
   vec3(0.15, 0.35, 0.65), // stone bricks blocks
   vec3(0.20, 0.09, 0.40), // polished blackstone and blackstone bricks
   vec3(0.20, 0.10, 0.55), // polished deepslate
   vec3(0.20, 0.30, 0.70), // waxed copper blocks
   vec3(0.20, 0.30, 0.71), // copper blocks
   vec3(0.35, 0.35, 0.99), // cobblestone blocks
   vec3(0.40, 0.25, 0.99), // polished granite
   vec3(0.40, 0.30, 0.99), // polished andesite
   vec3(0.40, 0.62, 0.99), // polished diorite
   vec3(0.49, 0.35, 0.85), // iron bars
   vec3(0.49, 0.50, 0.99), // blue ice
   vec3(0.49, 0.57, 0.99), // packed ice
   vec3(0.60, 0.00, 0.01), // ore blocks
   vec3(0.70, 0.00, 0.01)  // quartz blocks
);

// Water wave calculation - معطل لإزالة الظلال المتحركة
vec3 getWaterWave(float random, vec3 feetPos) {
   // تعطيل جميع حركات الماء لمنع الظلال المتحركة
   return vec3(0.0, 0.0, 0.0);
}

// Water texture strength calculation
float getWaterTextureStrength(float random) {
   // if the water is moving show all texture
   return !(abs(gl_Normal.x) < 0.01 && abs(gl_Normal.z) < 0.01) ? 1.0
      #if WATER_MIN_TEXTURE >= 0

         : 2.0*max(random - 0.5, 0.05*WATER_MIN_TEXTURE);

      #else

         : 0.0;

      #endif
}

// Reflection vignette effect
float getReflectionVignette(vec2 uv) {
   uv.y = min(uv.y, 1.0 - uv.y);
   uv.x *= 1.0 - uv.x;
   uv.y *= uv.y;

   return 1.0 - pow(1.0 - uv.x, 50.0*uv.y);
}

// Screen space reflection color calculation
vec4 getReflectionColor(float depth, vec3 normal, vec3 viewPos) {
   vec3 V = normalize(viewPos);
   vec3 R = normalize(reflect(V, normal));

   if (R.z >= -0.05) return vec4(0.0);

   float fresnel = 1.0 - dot(normal, -V);
   float grazingEpsilon = rescale(1.0 - abs(dot(R, normal)), 0.95, 1.0);
   float invR = 1.0 / abs(R.z);
   float invFar = 1.0 / (2.0*far);
   float lengthR = 1.0;
   vec3 oldPos = viewPos;

   for (int i = 0; i < SSR_MAX_STEPS; i++) {
      vec3 curPos = viewPos + R * lengthR;
      vec2 curUV  = view2screen(curPos).st;

      if (curUV.s < 0.0 || curUV.s > 1.0 || curUV.t < 0.0 || curUV.t > 1.0)
         break;

      float sceneDepth = texture2D(depthtex0, curUV).x;
      float sceneZ = screen2view(curUV, sceneDepth).z;
      float distanceEpsilon = clamp(abs(sceneZ) * invFar, 0.0, 1.0);
      float epsilon = 1.0 + 0.1*max(distanceEpsilon, grazingEpsilon);
      float diffZ = curPos.z - sceneZ * epsilon;

      if (diffZ < 0.0) {
         vec3 a = oldPos;
         vec3 b = curPos;

         for (int j = 0; j < SSR_BINARY_STEPS; j++) {
            vec3 mid = (a + b) * 0.5;

            curUV = view2screen(mid).st;
            sceneDepth = texture2D(depthtex0, curUV).x;
            sceneZ = screen2view(curUV, sceneDepth).z;

            if (sceneDepth + 0.001 <= depth) return vec4(0.0);

            if (-mid.z < -sceneZ) { a = mid; }
            else                  { b = mid; }
         }

         return vec4(texture2D(colortex0, curUV).rgb,
                     getReflectionVignette(curUV) * fresnel);
      }

      oldPos = curPos;
      lengthR += max(SSR_STEP_SIZE * abs(diffZ) * invR, 1.0);
   }

   return vec4(0.0);
}
