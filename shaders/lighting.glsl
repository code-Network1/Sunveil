// =============================================================================
// LIGHTING FUNCTIONS
// Combined lighting, ambient, diffuse, torch and shadow functions
// =============================================================================

uniform float screenBrightness;

// View position calculation
vec3 getViewPosition() {
   return (gl_ModelViewMatrix * gl_Vertex).xyz;
}

// Shadow distortion calculation
vec3 getShadowDistortion(vec3 shadowClipPos){
  shadowClipPos.xy /= 0.8*abs(shadowClipPos.xy) + 0.2;

  return shadowClipPos;
}

// Ambient lighting color calculation
vec4 getAmbientColor(float sunHeight) {
   vec4 ambient = texture2D(lightmap, vec2(AMBIENT_UV.s, lightUV.t));

   float x = ambient.g;
   float final = (((0.8494 * x + 0.9687) * x - 5.238) * x + 3.711) * x - 0.2864;

   final = max(0.0, final);

   // إضافة دفء للإضاءة المحيطة
   vec3 warmAmbient = ambient.rgb * vec3(1.1, 1.05, 0.9); // أكثر صفاراً ودفئاً

   ambient.rgb = mix(
      min(vec3(1.0), warmAmbient + vec3(final) * clamp(0.2*sunHeight, 0.0, 1.0) * AMBIENT_BRIGHTNESS),
      warmAmbient,
      screenBrightness
   );

   return ambient;
}

// Main light color calculation based on sun height
vec3 getLightColor(float sunHeight) {
   float sunRedness = 1.0 - clamp(0.2*sunHeight - 3.929, 0.0, 1.0);

   // جعل ضوء الشمس أكثر دفئاً وصفاراً
   vec3 lightColor = sunHeight > 0.01 ? normalize(vec3(1.0 + clamp(sunRedness, 0.15, 1.2) * SUN_WARMTH, 
                                                        1.1 * SUN_WARMTH, 
                                                        0.8))
                                      : MOON_COLOR;

   // fade transition between night and day
   lightColor *= clamp(0.1*abs(sunHeight) - 0.4453, 0.0, 1.0) * AMBIENT_BRIGHTNESS;

   // reduce color burn on dark spots
   return mix(vec3(luma(lightColor)), lightColor, lightUV.t);
}

// Diffuse lighting calculation
float getDiffuse(float skyLight) {
  bool isThin = mc_Entity.x == 10031.0 || mc_Entity.x == 10059.0
             || mc_Entity.x == 10175.0 || mc_Entity.x == 10176.0
             || (abs(gl_Normal.y) < 0.01 && abs(abs(gl_Normal.x) - abs(gl_Normal.z)) < 0.01);

  float baseLight = (isEyeInWater == 0 ? 1.0 : 0.75)
        //  reduce with fog
          * (1.0 - fogMix)
        //  reduce with rain strength
          * (1.0 - rainStrength)
        //  reduce with sky light
          * rescale(skyLight, 0.3137, 0.6235);

  // thin objects have constant diffuse
  return baseLight * (isThin ? 0.75 : 1.0);
}

// Diffuse lighting calculation with shadow light direction
float getDiffuseWithShadowLight(float skyLight, vec3 shadowLightDir) {
  bool isThin = mc_Entity.x == 10031.0 || mc_Entity.x == 10059.0
             || mc_Entity.x == 10175.0 || mc_Entity.x == 10176.0
             || (abs(gl_Normal.y) < 0.01 && abs(abs(gl_Normal.x) - abs(gl_Normal.z)) < 0.01);

  float baseLight = (isEyeInWater == 0 ? 1.0 : 0.75)
        //  reduce with fog
          * (1.0 - fogMix)
        //  reduce with rain strength
          * (1.0 - rainStrength)
        //  reduce with sky light
          * rescale(skyLight, 0.3137, 0.6235);

  //  thin objects have constant diffuse, others use shadow light direction
  return baseLight * (isThin ? 0.75 : clamp(2.5*dot(normalize(gl_NormalMatrix * gl_Normal),
                                                   normalize(shadowLightDir)), -0.3333, 1.0));
}

// Light strength calculation (simplified version)
float getLightStrength(vec3 feetPos) {
   return 1.0; // Default full light strength
}

// Light strength calculation with soft shadow filtering
#ifdef ENABLE_SHADOWS
float getLightStrengthWithShadows(vec3 feetPos, float diffuseValue, mat4 shadowModelViewMatrix, mat4 shadowProjectionMatrix, sampler2D shadowTexture) {
   #ifdef GBUFFERS_HAND
      return 0.5*diffuseValue;
   #endif

   // Shadow calculation with PCF for smooth edges
   vec3 pos = feetPos;
   
   float posDistance = dot(pos, pos);
   vec4 shadowView   = shadowModelViewMatrix * vec4(pos, 1.0);
   vec4 shadowClip   = shadowProjectionMatrix * shadowView;

   shadowClip.xyz = getShadowDistortion(shadowClip.xyz);

   vec3 shadowUV = 0.5 * shadowClip.xyz / shadowClip.w + 0.5;

   if (posDistance < SHADOW_MAX_DIST_SQUARED &&
      diffuseValue    > 0.0 && shadowUV.z < 1.0 &&
      shadowUV.s > 0.0 && shadowUV.s < 1.0 &&
      shadowUV.t > 0.0 && shadowUV.t < 1.0)
   {
      float shadowFade = 1.0 - posDistance * INV_SHADOW_MAX_DIST_SQUARED;
      
      // PCF (Percentage Closer Filtering) for smooth shadow edges
      float shadowSum = 0.0;
      float texelSize = 1.0 / shadowMapResolution;
      
      // 3x3 PCF sampling for smooth edges
      for(int x = -1; x <= 1; x++) {
         for(int y = -1; y <= 1; y++) {
            vec2 offset = vec2(float(x), float(y)) * texelSize;
            float shadowDepth = texture2D(shadowTexture, shadowUV.st + offset).x;
            float shadowTest = clamp(3.0*(shadowDepth - shadowUV.z) / shadowProjectionMatrix[2].z, 0.0, 1.0);
            shadowSum += shadowTest;
         }
      }
      
      // Average the 9 samples for smooth transition
      float smoothShadow = shadowSum / 9.0;
      
      return diffuseValue * (1.0 - shadowFade * smoothShadow);
   }

   return diffuseValue;
}
#endif

// Torch light strength calculation
float getTorchStrength(float torchLight) {
   return 1.1*rescale(torchLight, TORCH_UV_SCALE.x, TORCH_UV_SCALE.y);
}

// Torch color calculation
vec3 getTorchColor(vec3 ambient, vec3 feetPos) {
   #ifdef HAND_DYNAMIC_LIGHTING
      #ifdef heldBlockLightValue
         float strength = float(heldBlockLightValue);
         strength = max(torchStrength, min(1.0, strength / pow2(length(feetPos) + 1.5)));
      #else
         float strength = torchStrength;
      #endif
   #else
      float strength = torchStrength;
   #endif

   strength = smoothe(strength);
   
   #ifdef eyeBrightnessSmooth
      strength = mix(strength*strength, strength, eyeBrightnessSmooth.y/240.0);
   #endif

   return mix(TORCH_OUTER_COLOR, TORCH_COLOR, strength) * strength * max(0.0, 1.0 - luma(ambient));
}
