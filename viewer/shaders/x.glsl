
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
    if (channelGroup == 0) {
		vec3 roToPts0 = vec3(0.5801468,0.83572006,-6.647994) - ro;
        float t0 = dot(roToPts0, rd);
        vec3 localRo0 = (ro + rd * t0) * 0.05;
		vec3 roToPts1 = vec3(0.2712903,-4.87368,-0.042567372) - ro;
        float t1 = dot(roToPts1, rd);
        vec3 localRo1 = (ro + rd * t1) * 0.05;
        return vec4(localRo0.x,localRo0.y,localRo0.z,localRo1.x);
    } else if (channelGroup == 1) {
		vec3 roToPts1 = vec3(0.2712903,-4.87368,-0.042567372) - ro;
        float t1 = dot(roToPts1, rd);
        vec3 localRo1 = (ro + rd * t1) * 0.05;
		vec3 roToPts2 = vec3(0.6739054,7.1618786,-1.5459871) - ro;
        float t2 = dot(roToPts2, rd);
        vec3 localRo2 = (ro + rd * t2) * 0.05;
        return vec4(localRo1.y,localRo1.z,localRo2.x,localRo2.y);
    } else if (channelGroup == 2) {
		vec3 roToPts2 = vec3(0.6739054,7.1618786,-1.5459871) - ro;
        float t2 = dot(roToPts2, rd);
        vec3 localRo2 = (ro + rd * t2) * 0.05;
		vec3 roToPts3 = vec3(1.5990963,1.7287312,1.0730343) - ro;
        float t3 = dot(roToPts3, rd);
        vec3 localRo3 = (ro + rd * t3) * 0.05;
        return vec4(localRo2.z,localRo3.x,localRo3.y,localRo3.z);
    } else if (channelGroup == 3) {
		vec3 roToPts4 = vec3(-2.5067406,-2.3201346,9.7025585) - ro;
        float t4 = dot(roToPts4, rd);
        vec3 localRo4 = (ro + rd * t4) * 0.05;
		vec3 roToPts5 = vec3(5.12072,-8.126354,-1.6611004) - ro;
        float t5 = dot(roToPts5, rd);
        vec3 localRo5 = (ro + rd * t5) * 0.05;
        return vec4(localRo4.x,localRo4.y,localRo4.z,localRo5.x);
    } else if (channelGroup == 4) {
		vec3 roToPts5 = vec3(5.12072,-8.126354,-1.6611004) - ro;
        float t5 = dot(roToPts5, rd);
        vec3 localRo5 = (ro + rd * t5) * 0.05;
		vec3 roToPts6 = vec3(4.3237677,3.9127197,4.808569) - ro;
        float t6 = dot(roToPts6, rd);
        vec3 localRo6 = (ro + rd * t6) * 0.05;
        return vec4(localRo5.y,localRo5.z,localRo6.x,localRo6.y);
    } else if (channelGroup == 5) {
		vec3 roToPts6 = vec3(4.3237677,3.9127197,4.808569) - ro;
        float t6 = dot(roToPts6, rd);
        vec3 localRo6 = (ro + rd * t6) * 0.05;
		vec3 roToPts7 = vec3(8.572367,3.8339853,1.616847) - ro;
        float t7 = dot(roToPts7, rd);
        vec3 localRo7 = (ro + rd * t7) * 0.05;
        return vec4(localRo6.z,localRo7.x,localRo7.y,localRo7.z);
    } else if (channelGroup == 6) {
		vec3 roToPts8 = vec3(0.76907635,0.33021164,-5.7853556) - ro;
        float t8 = dot(roToPts8, rd);
        vec3 localRo8 = (ro + rd * t8) * 0.05;
		vec3 roToPts9 = vec3(5.7951603,-0.74453926,1.5863113) - ro;
        float t9 = dot(roToPts9, rd);
        vec3 localRo9 = (ro + rd * t9) * 0.05;
        return vec4(localRo8.x,localRo8.y,localRo8.z,localRo9.x);
    } else if (channelGroup == 7) {
		vec3 roToPts9 = vec3(5.7951603,-0.74453926,1.5863113) - ro;
        float t9 = dot(roToPts9, rd);
        vec3 localRo9 = (ro + rd * t9) * 0.05;
		vec3 roToPts10 = vec3(4.613962,3.316719,5.5536127) - ro;
        float t10 = dot(roToPts10, rd);
        vec3 localRo10 = (ro + rd * t10) * 0.05;
        return vec4(localRo9.y,localRo9.z,localRo10.x,localRo10.y);
    } else if (channelGroup == 8) {
		vec3 roToPts10 = vec3(4.613962,3.316719,5.5536127) - ro;
        float t10 = dot(roToPts10, rd);
        vec3 localRo10 = (ro + rd * t10) * 0.05;
		vec3 roToPts11 = vec3(4.8617897,0.45850945,1.9731839) - ro;
        float t11 = dot(roToPts11, rd);
        vec3 localRo11 = (ro + rd * t11) * 0.05;
        return vec4(localRo10.z,localRo11.x,localRo11.y,localRo11.z);
    } else if (channelGroup == 9) {
		vec3 roToPts12 = vec3(2.0751033,2.0605793,4.393199) - ro;
        float t12 = dot(roToPts12, rd);
        vec3 localRo12 = (ro + rd * t12) * 0.05;
		vec3 roToPts13 = vec3(4.1539135,-3.2125068,6.9581347) - ro;
        float t13 = dot(roToPts13, rd);
        vec3 localRo13 = (ro + rd * t13) * 0.05;
        return vec4(localRo12.x,localRo12.y,localRo12.z,localRo13.x);
    } else if (channelGroup == 10) {
		vec3 roToPts13 = vec3(4.1539135,-3.2125068,6.9581347) - ro;
        float t13 = dot(roToPts13, rd);
        vec3 localRo13 = (ro + rd * t13) * 0.05;
		vec3 roToPts14 = vec3(1.4001818,2.8568153,6.1380334) - ro;
        float t14 = dot(roToPts14, rd);
        vec3 localRo14 = (ro + rd * t14) * 0.05;
        return vec4(localRo13.y,localRo13.z,localRo14.x,localRo14.y);
    } else if (channelGroup == 11) {
		vec3 roToPts14 = vec3(1.4001818,2.8568153,6.1380334) - ro;
        float t14 = dot(roToPts14, rd);
        vec3 localRo14 = (ro + rd * t14) * 0.05;
		vec3 roToPts15 = vec3(-1.8830991,-7.299734,2.5409575) - ro;
        float t15 = dot(roToPts15, rd);
        vec3 localRo15 = (ro + rd * t15) * 0.05;
        return vec4(localRo14.z,localRo15.x,localRo15.y,localRo15.z);
    } else {
        return vec4(rd, 1.0);
    }
}
