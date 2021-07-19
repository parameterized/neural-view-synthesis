
uniform vec3 camPos;
uniform vec3 camTarget;
uniform float[25] shValsR;
uniform float[25] shValsG;
uniform float[25] shValsB;

#define PI 3.14159265358979323846

mat3 setCamera( in vec3 ro, in vec3 ta, float cr )
{
	vec3 cw = normalize(ta-ro);
	vec3 cp = vec3(sin(cr), cos(cr),0.0);
	vec3 cu = normalize( cross(cw,cp) );
	vec3 cv = normalize( cross(cu,cw) );
    return mat3( cu, cv, cw );
}

// spherical harmonic constants
float shc1 = 1.0 / 2.0 * sqrt(1.0 / PI);
float shc2 = sqrt(3.0 / (4.0 * PI));
float shc3 = 1.0 / 2.0 * sqrt(15.0 / PI);
float shc4 = 1.0 / 4.0 * sqrt(5.0 / PI);
float shc5 = 1.0 / 4.0 * sqrt(15.0 / PI);
float shc6 = 1.0 / 4.0 * sqrt(35.0 / (2.0 * PI));
float shc7 = 1.0 / 2.0 * sqrt(105.0 / PI);
float shc8 = 1.0 / 4.0 * sqrt(21.0 / (2.0 * PI));
float shc9 = 1.0 / 4.0 * sqrt(7.0 / PI);
float shc10 = 1.0 / 4.0 * sqrt(105.0 / PI);
float shc11 = 3.0 / 4.0 * sqrt(35.0 / PI);
float shc12 = 3.0 / 4.0 * sqrt(35.0 / (2.0 * PI));
float shc13 = 3.0 / 4.0 * sqrt(5.0 / PI);
float shc14 = 3.0 / 4.0 * sqrt(5.0 / (2.0 * PI));
float shc15 = 3.0 / 16.0 * sqrt(1.0 / PI);
float shc16 = 3.0 / 8.0 * sqrt(5.0 / PI);
float shc17 = 3.0 / 16.0 * sqrt(35.0 / PI);

float sh(vec3 rd, float[25] v)
{
    float x = rd.x, y = rd.y, z = rd.z;
    float xx = x*x, xy = x*y, xz = x*z, yy = y*y, yz = y*z, zz = z*z;
    float y00 = shc1;
    float y1n1 = shc2 * y;
    float y10 = shc2 * z;
    float y11 = shc2 * x;
    float y2n2 = shc3 * xy;
    float y2n1 = shc3 * yz;
    float y20 = shc4 * (-xx - yy + 2.0 * zz);
    float y21 = shc3 * xz;
    float y22 = shc5 * (xx - yy);
    float y3n3 = shc6 * (3.0 * xx - yy) * y;
    float y3n2 = shc7 * xy * z;
    float y3n1 = shc8 * y * (4.0 * zz - xx - yy);
    float y30 = shc9 * z * (2.0 * zz - 3.0 * xx - 3.0 * yy);
    float y31 = shc8 * x * (4.0 * zz - xx - yy);
    float y32 = shc10 * (xx - yy) * z;
    float y33 = shc6 * (xx - 3.0 * yy) * x;
    float y4n4 = shc11 * xy * (xx - yy);
    float y4n3 = shc12 * (3.0 * xx - yy) * yz;
    float y4n2 = shc13 * xy * (7.0 * zz - 1.0);
    float y4n1 = shc14 * yz * (8.0 * zz - 3.0);
    float y40 = shc15 * (35.0 * zz * zz - 30 * zz + 3.0);
    float y41 = shc14 * xz * (7.0 * zz - 3.0);
    float y42 = shc16 * (xx - yy) * (7.0 * zz - 1.0);
    float y43 = shc12 * (xx - 3.0 * yy) * xz;
    float y44 = shc17 * (xx * (xx - 3.0 * yy) - yy * (3.0 * xx - yy));

    float c = y00 * v[0] + y1n1 * v[1] + y10 * v[2] + y11 * v[3] + y2n2 * v[4] + y2n1 * v[5] + y20 * v[6] + y21 * v[7] + y22 * v[8] + y3n3 * v[9] + y3n2 * v[10] + y3n1 * v[11] + y30 * v[12] + y31 * v[13] + y32 * v[14] + y33 * v[15] + y4n4 * v[16] + y4n3 * v[17] + y4n2 * v[18] + y4n1 * v[19] + y40 * v[20] + y41 * v[21] + y42 * v[22] + y43 * v[23] + y44 * v[24];
    return c * 0.5 + 0.5;
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec2 cs = vec2(512.0);

    vec2 p = (2.0 * screen_coords - cs) / cs.y;
    p.y = -p.y;
    vec3 ro = vec3(camPos);
    vec3 ta = vec3(camTarget);
    mat3 ca = setCamera(ro, ta, 0.0);
    vec3 rd = ca * normalize(vec3(p.xy, 2.0));

    float r = sh(rd, shValsR) + mod(ro.x, 0.0001);
    float g = sh(rd, shValsG);
    float b = sh(rd, shValsB);
    return vec4(vec3(r, g, b), 1.0);
}
