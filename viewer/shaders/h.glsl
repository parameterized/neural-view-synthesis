
uniform vec3 camPos;
uniform vec3 camTarget;
uniform Image dense1;

mat3 setCamera( in vec3 ro, in vec3 ta, float cr )
{
	vec3 cw = normalize(ta-ro);
	vec3 cp = vec3(sin(cr), cos(cr),0.0);
	vec3 cu = normalize( cross(cw,cp) );
	vec3 cv = normalize( cross(cu,cw) );
    return mat3( cu, cv, cw );
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec2 cs = vec2(64.0);
    vec2 uv = mod(screen_coords, cs);

    vec2 p = (2.0 * uv - cs) / cs.y;
    p.y = -p.y;
    vec3 ro = vec3(camPos);
    vec3 ta = vec3(camTarget);
    mat3 ca = setCamera(ro, ta, 0.0);
    vec3 rd = ca * normalize(vec3(p.xy, 2.0));

    float ci = floor(screen_coords.x / cs.x);
    vec2 dss = vec2(7.0, 16.0);

    // inputs
    float x0 = ro.x;
    float x1 = ro.y;
    float x2 = ro.z;
    float x3 = rd.x;
    float x4 = rd.y;
    float x5 = rd.z;

vec4 d1_0 = Texel(dense1, vec2(0.5, ci + 0.5) / dss);
vec4 d1_1 = Texel(dense1, vec2(1.5, ci + 0.5) / dss);
vec4 d1_2 = Texel(dense1, vec2(2.5, ci + 0.5) / dss);
vec4 d1_3 = Texel(dense1, vec2(3.5, ci + 0.5) / dss);
vec4 d1_4 = Texel(dense1, vec2(4.5, ci + 0.5) / dss);
vec4 d1_5 = Texel(dense1, vec2(5.5, ci + 0.5) / dss);
vec4 d1_6 = Texel(dense1, vec2(6.5, ci + 0.5) / dss);

float h0 = x0 * d1_0.x + x1 * d1_1.x + x2 * d1_2.x + x3 * d1_3.x + x4 * d1_4.x + x5 * d1_5.x + d1_6.x;
float h1 = x0 * d1_0.y + x1 * d1_1.y + x2 * d1_2.y + x3 * d1_3.y + x4 * d1_4.y + x5 * d1_5.y + d1_6.y;
float h2 = x0 * d1_0.z + x1 * d1_1.z + x2 * d1_2.z + x3 * d1_3.z + x4 * d1_4.z + x5 * d1_5.z + d1_6.z;
float h3 = x0 * d1_0.w + x1 * d1_1.w + x2 * d1_2.w + x3 * d1_3.w + x4 * d1_4.w + x5 * d1_5.w + d1_6.w;

    return vec4(h0, h1, h2, h3);
}
