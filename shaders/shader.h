#define SHADOW_DARKNESS 0.3 // كثافة ظلال ناعمة ومتدرجة
#define LIGHT_BRIGHTNESS 1.3 //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0] زيادة الإضاءة الصفراء

#define ENABLE_FOG
#define OVERWORLD_FOG_MAX_SLIDER 7 //[0 1 2 3 4 5 6 7 8 9 10]
#define OVERWORLD_FOG_MIN_SLIDER 0 //[0 1 2 3 4 5 6 7 8 9 10]

#define TORCH_R 1.0 //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define TORCH_G 0.9 //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0] زيادة الأصفر
#define TORCH_B 0.5 //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0] تقليل الأزرق
#define TORCH_OUTER_R 1.0  //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define TORCH_OUTER_G 0.7 //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0] زيادة الأصفر الخارجي
#define TORCH_OUTER_B 0.1  //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0] تقليل الأزرق الخارجي
#define MOON_R 0.1  //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define MOON_G 0.15 //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define MOON_B 0.3  //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]

#define ENABLE_BLOCK_REFLECTIONS
#define REFLECTIONS 3       //[0 1 2 3 4 5 6 7 8 9 10] تقليل الانعكاسات
#define SSR_MAX_STEPS 10     //[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 24 32 64 96 128 256 512]
#define SSR_STEP_SIZE 1.6    //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define SSR_BINARY_STEPS 4   //[1 2 3 4 5 6 7 8 9 10]
#define REFLECTIONS_PIXEL 16 //[4 8 16 32 64 128 256 512]

#define SHADOW_PIXEL 64     // جودة عالية لتنعيم الحواف
#define SHADOW_BLUENESS 0.0 //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5] إزالة الزرقة من الظلال

const int   shadowMapResolution = 2048;  // دقة عالية لتنعيم حواف الظلال
const float shadowDistance      = 128.0; // مسافة الظلال
const float shadowIntervalSize  = 2.0;  // فترات أصغر لتفاصيل أدق
const float shadowDistanceRenderMul = 1.0;
const float entityShadowDistanceMul = 0.5; // مسافة ظلال محسنة للكائنات
const float sunPathRotation = -20.0; // زاوية مسار الشمس لحركة طبيعية للظلال

// إعدادات تنعيم الظلال
#define SHADOW_FILTER_RADIUS 1.5  // نصف قطر تنعيم الحواف
#define SHADOW_SMOOTHNESS 0.8     // درجة نعومة الانتقال

#define WATER_MIN_TEXTURE 4  //[-1 0 1 2 3 4 5 6 7 8 9 10]
#define WATER_WAVE_SIZE 1    //[0 1 2 3 4 5 6 7 8 9 10]
#define WATER_WAVE_SPEED 2   //[1 2 3 4 5 6 7 8 9 10]
#define WATER_BRIGHTNESS 0.65 //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define WATER_B 1.2          //[1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0]
#define WATER_A 0.35         //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]

#define WIND_SPEED 1.5       //[0.0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0]
#define WIND_STRENGTH 0.0    //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0] معطل لإزالة الظلال المتحركة

#define SUN_WARMTH 1.2       //[0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5] دفء ضوء الشمس
#define AMBIENT_BRIGHTNESS 1.1 //[0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5] إضاءة البيئة المحيطة

#define END_STARS_SPEED  0.05  //[0.002 0.005 0.01 0.02 0.05 0.1 0.5]
#define END_STARS_AMOUNT 256.0 //[128.0 256.0 512.0 1024.0 2048.0]
#define END_STARS_FLOOR  256.0
#define END_STARS_OPACITY 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

//#define FLAT_LIGHTING  // معطل لاستعادة الإضاءة الطبيعية
#define GLOWING_ORES
#define HIGHLIGHT_WAXED
#define SHADOW_ENTITY 0 //[-1 0 1]

// نظام ظلال مبسط ومستقر
#define ENABLE_SHADOWS

#if MC_VERSION >= 11300
   #define HAND_DYNAMIC_LIGHTING
#endif

// optifine needs these to show on menu
#ifdef ENABLE_FOG
#endif
#ifdef FLAT_LIGHTING
#endif
#ifdef SHADOW_ENTITY
#endif

//----------------------------------------------------------------------------//

#define MIN_REFLECTIVITY 0.01
#define WATER_REFLECTIVITY 0.6
#define GLASS_REFLECTIVITY 0.9

#define HALF_PI 1.570796326
#define PI 3.141592653
#define TAU 6.283185307
#define NOON 0.25 // 6000
#define SUNSET 0.5325 // 12780
#define MIDNIGHT 0.75 // 18000
#define SUNRISE 0.9675 // 23220

const float INV_PI = 1.0 / PI;
const float INV_TAU = 1.0 / TAU;

const float NORMALIZE_TIME = 1.0/24000.0;

const float OVERWORLD_FOG_MIN = 1.0 - 0.1*OVERWORLD_FOG_MAX_SLIDER;
const float OVERWORLD_FOG_MAX = 1.0 - 0.1*OVERWORLD_FOG_MIN_SLIDER;

const vec2 AMBIENT_UV = vec2(8.0/255.0, 247.0/255.0);
const vec2 TORCH_UV_SCALE = vec2(8.0/255.0, 231.0/255.0);
const vec3 TORCH_COLOR = vec3(TORCH_R, TORCH_G, TORCH_B);
const vec3 TORCH_OUTER_COLOR = vec3(TORCH_OUTER_R, TORCH_OUTER_G, TORCH_OUTER_B);
const vec3 MOON_COLOR = vec3(MOON_R, MOON_G, MOON_B);

const vec4 END_STARS_DRAG = vec4(200, 500, 100, 100);
const vec3 END_AMBIENT    = vec3(0.83, 0.7, 1.0);

const float SHADOW_MAX_DIST_SQUARED = shadowDistance * shadowDistance;
const float INV_SHADOW_MAX_DIST_SQUARED = 1.0/SHADOW_MAX_DIST_SQUARED;