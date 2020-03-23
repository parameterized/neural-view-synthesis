
# h.glsl
s = """
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
"""

# d1 weights (for ci group of 4 channels)
s += '\n'
for i in range(6 + 1):
    s += 'vec4 d1_{} = Texel(dense1, vec2({}, ci + 0.5) / dss);\n'.format(i, i + 0.5)

# h
s += '\n'
for i in range(4):
    c = 'xyzw'[i]
    x = []
    for j in range(6):
        x.append('x{0} * d1_{0}.{1}'.format(j, c))
    # bias
    x.append('d1_6.{}'.format(c))
    s += 'float h{} = {};\n'.format(i, ' + '.join(x))

s += """
    return vec4(h0, h1, h2, h3);
}
"""

with open('shaders/h.glsl', 'w') as f:
    f.write(s)



# y.glsl
s = """
uniform Image h;
uniform Image dense2;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec2 cs = vec2(64.0);
    vec2 uv = mod(screen_coords, cs);
    vec2 hss = vec2(cs.x * 16.0, cs.y);
    vec2 dss = vec2(65.0, 1.0);
"""

# inputs / activations
s += '\n'
for i in range(int(64 / 4)):
    s += 'vec4 h{0} = max(Texel(h, vec2(uv.x + {0}.0 * cs.x, uv.y) / hss), 0.0);\n'.format(i)

# d2 weights
s += '\n'
for i in range(64 + 1):
    s += 'vec4 d2_{} = Texel(dense2, vec2({}, 0.5) / dss);\n'.format(i, i + 0.5)

# y
s += '\n'
for i in range(3):
    c = 'xyz'[i]
    x = []
    for j in range(64):
        c2 = 'xyzw'[j % 4]
        x.append('h{}.{} * d2_{}.{}'.format(int(j / 4), c2, j, c))
    # bias
    x.append('d2_64.{}'.format(c))
    s += 'float y{} = {};\n'.format(i, ' + '.join(x))

s += """
    return clamp(vec4(y0, y1, y2, 1.0), 0.0, 1.0);
}
"""

with open('shaders/y.glsl', 'w') as f:
    f.write(s)
