
import math

def gen(model):
    ### x.glsl ###
    s = """
uniform vec2 screenSize;
uniform vec3 camPos;
uniform vec3 camTarget;

mat3 setCamera(in vec3 ro, in vec3 ta, float cr)
{
    vec3 cw = normalize(ta - ro);
    vec3 cp = vec3(sin(cr), cos(cr), 0.0);
    vec3 cu = normalize(cross(cw, cp));
    vec3 cv = normalize(cross(cu, cw));
    return mat3(cu, cv, cw);
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    int channelGroup = int(screen_coords.x / screenSize.x);
    vec2 uv = mod(screen_coords, screenSize) / screenSize;
    uv -= 0.5;
    uv.x = -uv.x * screenSize.x / screenSize.y;
    mat3 ca = setCamera(camPos, camTarget, 0.0);
    vec3 ro = camPos;
    vec3 rd = ca * normalize(vec3(uv, 1.0));

    // localize ray to scene points
    """

    scene_pts = model.scene_points.cpu().numpy()
    # more code necessary if it doesn't divide evenly
    for i in range(math.ceil(16 * 3 / 4)):
        # switch is unsupported & using computed indices is slower
        s += f'if (channelGroup == {i}) {{'
        for j in range(2):
            pts_idx = i * 4 // 3 + j
            point = f'vec3({",".join(map(str, scene_pts[pts_idx]))})'
            s += """\n\t\tvec3 roToPts{0} = {1} - ro;
        float t{0} = dot(roToPts{0}, rd);
        vec3 localRo{0} = (ro + rd * t{0}) * 0.05;""".format(pts_idx, point)
        
        outs = [f'{(i * 4 + j) // 3}.{chr(ord("x") + (i * 4 + j) % 3)}' for j in range(4)]
        s += f"""
        return vec4({','.join(['localRo' + v for v in outs])});
    }} else """

    s += """{
        return vec4(rd, 1.0);
    }
}
"""
    with open('viewer/shaders/x.glsl', 'w') as f:
        f.write(s)


    ### l[i].glsl ###
    for layerIdx, layer in enumerate(model.layers):
        linear = layer if layer == model.layers[-1] else layer.linear
        w, b = [v.detach().cpu().numpy() for v in linear.parameters()]
        in_groups = math.ceil(linear.in_features / 4)
        s = f"""
uniform vec2 screenSize;
uniform Image h;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{{
    vec2 sc = mod(screen_coords, screenSize);
    int ig = {in_groups}; // # of input channel groups
    vec2 is = vec2(screenSize.x * ig, screenSize.y); // input size
    vec2 o = vec2(screenSize.x, 0.0); // offset

"""
        for i in range(in_groups):
            s += f'\tvec4 h{i} = Texel(h, (sc + o * {float(i)}) / is);\n'

        s += """
    int channelGroup = int(screen_coords.x / screenSize.x);
    """
        for i in range(math.ceil(linear.out_features / 4)):
            s += f'if (channelGroup == {i}) {{\n'
            for j in range(4):
                if i * 4 + j >= linear.out_features:
                    s += f'\t\tfloat c{j} = 1.0;\n'
                else:
                    weights = w[i * 4 + j]
                    s += f'\t\tfloat c{j} = ' \
                    + '+'.join([
                        f'h{k // 4}[{k % 4}]*({v:.8f})'
                        for k, v in enumerate(weights)]) \
                    + f'+({b[i * 4 + j]:.8f});\n'
            if layer == model.layers[-1]:
                s += """\t\treturn clamp(vec4(c0, c1, c2, c3), 0.0, 1.0);
    } else """
            else:
                s += f"""\t\treturn sin({float(layer.omega_0)} * vec4(c0, c1, c2, c3));
    }} else """
        s = s[:-6] + '\n}\n'
        
        with open(f'viewer/shaders/l{layerIdx}.glsl', 'w') as f:
            f.write(s)
