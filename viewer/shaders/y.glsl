
uniform Image h;
uniform Image dense2;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec2 cs = vec2(64.0);
    vec2 uv = mod(screen_coords, cs);
    vec2 hss = vec2(cs.x * 16.0, cs.y);
    vec2 dss = vec2(65.0, 1.0);

vec4 h0 = max(Texel(h, vec2(uv.x + 0.0 * cs.x, uv.y) / hss), 0.0);
vec4 h1 = max(Texel(h, vec2(uv.x + 1.0 * cs.x, uv.y) / hss), 0.0);
vec4 h2 = max(Texel(h, vec2(uv.x + 2.0 * cs.x, uv.y) / hss), 0.0);
vec4 h3 = max(Texel(h, vec2(uv.x + 3.0 * cs.x, uv.y) / hss), 0.0);
vec4 h4 = max(Texel(h, vec2(uv.x + 4.0 * cs.x, uv.y) / hss), 0.0);
vec4 h5 = max(Texel(h, vec2(uv.x + 5.0 * cs.x, uv.y) / hss), 0.0);
vec4 h6 = max(Texel(h, vec2(uv.x + 6.0 * cs.x, uv.y) / hss), 0.0);
vec4 h7 = max(Texel(h, vec2(uv.x + 7.0 * cs.x, uv.y) / hss), 0.0);
vec4 h8 = max(Texel(h, vec2(uv.x + 8.0 * cs.x, uv.y) / hss), 0.0);
vec4 h9 = max(Texel(h, vec2(uv.x + 9.0 * cs.x, uv.y) / hss), 0.0);
vec4 h10 = max(Texel(h, vec2(uv.x + 10.0 * cs.x, uv.y) / hss), 0.0);
vec4 h11 = max(Texel(h, vec2(uv.x + 11.0 * cs.x, uv.y) / hss), 0.0);
vec4 h12 = max(Texel(h, vec2(uv.x + 12.0 * cs.x, uv.y) / hss), 0.0);
vec4 h13 = max(Texel(h, vec2(uv.x + 13.0 * cs.x, uv.y) / hss), 0.0);
vec4 h14 = max(Texel(h, vec2(uv.x + 14.0 * cs.x, uv.y) / hss), 0.0);
vec4 h15 = max(Texel(h, vec2(uv.x + 15.0 * cs.x, uv.y) / hss), 0.0);

vec4 d2_0 = Texel(dense2, vec2(0.5, 0.5) / dss);
vec4 d2_1 = Texel(dense2, vec2(1.5, 0.5) / dss);
vec4 d2_2 = Texel(dense2, vec2(2.5, 0.5) / dss);
vec4 d2_3 = Texel(dense2, vec2(3.5, 0.5) / dss);
vec4 d2_4 = Texel(dense2, vec2(4.5, 0.5) / dss);
vec4 d2_5 = Texel(dense2, vec2(5.5, 0.5) / dss);
vec4 d2_6 = Texel(dense2, vec2(6.5, 0.5) / dss);
vec4 d2_7 = Texel(dense2, vec2(7.5, 0.5) / dss);
vec4 d2_8 = Texel(dense2, vec2(8.5, 0.5) / dss);
vec4 d2_9 = Texel(dense2, vec2(9.5, 0.5) / dss);
vec4 d2_10 = Texel(dense2, vec2(10.5, 0.5) / dss);
vec4 d2_11 = Texel(dense2, vec2(11.5, 0.5) / dss);
vec4 d2_12 = Texel(dense2, vec2(12.5, 0.5) / dss);
vec4 d2_13 = Texel(dense2, vec2(13.5, 0.5) / dss);
vec4 d2_14 = Texel(dense2, vec2(14.5, 0.5) / dss);
vec4 d2_15 = Texel(dense2, vec2(15.5, 0.5) / dss);
vec4 d2_16 = Texel(dense2, vec2(16.5, 0.5) / dss);
vec4 d2_17 = Texel(dense2, vec2(17.5, 0.5) / dss);
vec4 d2_18 = Texel(dense2, vec2(18.5, 0.5) / dss);
vec4 d2_19 = Texel(dense2, vec2(19.5, 0.5) / dss);
vec4 d2_20 = Texel(dense2, vec2(20.5, 0.5) / dss);
vec4 d2_21 = Texel(dense2, vec2(21.5, 0.5) / dss);
vec4 d2_22 = Texel(dense2, vec2(22.5, 0.5) / dss);
vec4 d2_23 = Texel(dense2, vec2(23.5, 0.5) / dss);
vec4 d2_24 = Texel(dense2, vec2(24.5, 0.5) / dss);
vec4 d2_25 = Texel(dense2, vec2(25.5, 0.5) / dss);
vec4 d2_26 = Texel(dense2, vec2(26.5, 0.5) / dss);
vec4 d2_27 = Texel(dense2, vec2(27.5, 0.5) / dss);
vec4 d2_28 = Texel(dense2, vec2(28.5, 0.5) / dss);
vec4 d2_29 = Texel(dense2, vec2(29.5, 0.5) / dss);
vec4 d2_30 = Texel(dense2, vec2(30.5, 0.5) / dss);
vec4 d2_31 = Texel(dense2, vec2(31.5, 0.5) / dss);
vec4 d2_32 = Texel(dense2, vec2(32.5, 0.5) / dss);
vec4 d2_33 = Texel(dense2, vec2(33.5, 0.5) / dss);
vec4 d2_34 = Texel(dense2, vec2(34.5, 0.5) / dss);
vec4 d2_35 = Texel(dense2, vec2(35.5, 0.5) / dss);
vec4 d2_36 = Texel(dense2, vec2(36.5, 0.5) / dss);
vec4 d2_37 = Texel(dense2, vec2(37.5, 0.5) / dss);
vec4 d2_38 = Texel(dense2, vec2(38.5, 0.5) / dss);
vec4 d2_39 = Texel(dense2, vec2(39.5, 0.5) / dss);
vec4 d2_40 = Texel(dense2, vec2(40.5, 0.5) / dss);
vec4 d2_41 = Texel(dense2, vec2(41.5, 0.5) / dss);
vec4 d2_42 = Texel(dense2, vec2(42.5, 0.5) / dss);
vec4 d2_43 = Texel(dense2, vec2(43.5, 0.5) / dss);
vec4 d2_44 = Texel(dense2, vec2(44.5, 0.5) / dss);
vec4 d2_45 = Texel(dense2, vec2(45.5, 0.5) / dss);
vec4 d2_46 = Texel(dense2, vec2(46.5, 0.5) / dss);
vec4 d2_47 = Texel(dense2, vec2(47.5, 0.5) / dss);
vec4 d2_48 = Texel(dense2, vec2(48.5, 0.5) / dss);
vec4 d2_49 = Texel(dense2, vec2(49.5, 0.5) / dss);
vec4 d2_50 = Texel(dense2, vec2(50.5, 0.5) / dss);
vec4 d2_51 = Texel(dense2, vec2(51.5, 0.5) / dss);
vec4 d2_52 = Texel(dense2, vec2(52.5, 0.5) / dss);
vec4 d2_53 = Texel(dense2, vec2(53.5, 0.5) / dss);
vec4 d2_54 = Texel(dense2, vec2(54.5, 0.5) / dss);
vec4 d2_55 = Texel(dense2, vec2(55.5, 0.5) / dss);
vec4 d2_56 = Texel(dense2, vec2(56.5, 0.5) / dss);
vec4 d2_57 = Texel(dense2, vec2(57.5, 0.5) / dss);
vec4 d2_58 = Texel(dense2, vec2(58.5, 0.5) / dss);
vec4 d2_59 = Texel(dense2, vec2(59.5, 0.5) / dss);
vec4 d2_60 = Texel(dense2, vec2(60.5, 0.5) / dss);
vec4 d2_61 = Texel(dense2, vec2(61.5, 0.5) / dss);
vec4 d2_62 = Texel(dense2, vec2(62.5, 0.5) / dss);
vec4 d2_63 = Texel(dense2, vec2(63.5, 0.5) / dss);
vec4 d2_64 = Texel(dense2, vec2(64.5, 0.5) / dss);

float y0 = h0.x * d2_0.x + h0.y * d2_1.x + h0.z * d2_2.x + h0.w * d2_3.x + h1.x * d2_4.x + h1.y * d2_5.x + h1.z * d2_6.x + h1.w * d2_7.x + h2.x * d2_8.x + h2.y * d2_9.x + h2.z * d2_10.x + h2.w * d2_11.x + h3.x * d2_12.x + h3.y * d2_13.x + h3.z * d2_14.x + h3.w * d2_15.x + h4.x * d2_16.x + h4.y * d2_17.x + h4.z * d2_18.x + h4.w * d2_19.x + h5.x * d2_20.x + h5.y * d2_21.x + h5.z * d2_22.x + h5.w * d2_23.x + h6.x * d2_24.x + h6.y * d2_25.x + h6.z * d2_26.x + h6.w * d2_27.x + h7.x * d2_28.x + h7.y * d2_29.x + h7.z * d2_30.x + h7.w * d2_31.x + h8.x * d2_32.x + h8.y * d2_33.x + h8.z * d2_34.x + h8.w * d2_35.x + h9.x * d2_36.x + h9.y * d2_37.x + h9.z * d2_38.x + h9.w * d2_39.x + h10.x * d2_40.x + h10.y * d2_41.x + h10.z * d2_42.x + h10.w * d2_43.x + h11.x * d2_44.x + h11.y * d2_45.x + h11.z * d2_46.x + h11.w * d2_47.x + h12.x * d2_48.x + h12.y * d2_49.x + h12.z * d2_50.x + h12.w * d2_51.x + h13.x * d2_52.x + h13.y * d2_53.x + h13.z * d2_54.x + h13.w * d2_55.x + h14.x * d2_56.x + h14.y * d2_57.x + h14.z * d2_58.x + h14.w * d2_59.x + h15.x * d2_60.x + h15.y * d2_61.x + h15.z * d2_62.x + h15.w * d2_63.x + d2_64.x;
float y1 = h0.x * d2_0.y + h0.y * d2_1.y + h0.z * d2_2.y + h0.w * d2_3.y + h1.x * d2_4.y + h1.y * d2_5.y + h1.z * d2_6.y + h1.w * d2_7.y + h2.x * d2_8.y + h2.y * d2_9.y + h2.z * d2_10.y + h2.w * d2_11.y + h3.x * d2_12.y + h3.y * d2_13.y + h3.z * d2_14.y + h3.w * d2_15.y + h4.x * d2_16.y + h4.y * d2_17.y + h4.z * d2_18.y + h4.w * d2_19.y + h5.x * d2_20.y + h5.y * d2_21.y + h5.z * d2_22.y + h5.w * d2_23.y + h6.x * d2_24.y + h6.y * d2_25.y + h6.z * d2_26.y + h6.w * d2_27.y + h7.x * d2_28.y + h7.y * d2_29.y + h7.z * d2_30.y + h7.w * d2_31.y + h8.x * d2_32.y + h8.y * d2_33.y + h8.z * d2_34.y + h8.w * d2_35.y + h9.x * d2_36.y + h9.y * d2_37.y + h9.z * d2_38.y + h9.w * d2_39.y + h10.x * d2_40.y + h10.y * d2_41.y + h10.z * d2_42.y + h10.w * d2_43.y + h11.x * d2_44.y + h11.y * d2_45.y + h11.z * d2_46.y + h11.w * d2_47.y + h12.x * d2_48.y + h12.y * d2_49.y + h12.z * d2_50.y + h12.w * d2_51.y + h13.x * d2_52.y + h13.y * d2_53.y + h13.z * d2_54.y + h13.w * d2_55.y + h14.x * d2_56.y + h14.y * d2_57.y + h14.z * d2_58.y + h14.w * d2_59.y + h15.x * d2_60.y + h15.y * d2_61.y + h15.z * d2_62.y + h15.w * d2_63.y + d2_64.y;
float y2 = h0.x * d2_0.z + h0.y * d2_1.z + h0.z * d2_2.z + h0.w * d2_3.z + h1.x * d2_4.z + h1.y * d2_5.z + h1.z * d2_6.z + h1.w * d2_7.z + h2.x * d2_8.z + h2.y * d2_9.z + h2.z * d2_10.z + h2.w * d2_11.z + h3.x * d2_12.z + h3.y * d2_13.z + h3.z * d2_14.z + h3.w * d2_15.z + h4.x * d2_16.z + h4.y * d2_17.z + h4.z * d2_18.z + h4.w * d2_19.z + h5.x * d2_20.z + h5.y * d2_21.z + h5.z * d2_22.z + h5.w * d2_23.z + h6.x * d2_24.z + h6.y * d2_25.z + h6.z * d2_26.z + h6.w * d2_27.z + h7.x * d2_28.z + h7.y * d2_29.z + h7.z * d2_30.z + h7.w * d2_31.z + h8.x * d2_32.z + h8.y * d2_33.z + h8.z * d2_34.z + h8.w * d2_35.z + h9.x * d2_36.z + h9.y * d2_37.z + h9.z * d2_38.z + h9.w * d2_39.z + h10.x * d2_40.z + h10.y * d2_41.z + h10.z * d2_42.z + h10.w * d2_43.z + h11.x * d2_44.z + h11.y * d2_45.z + h11.z * d2_46.z + h11.w * d2_47.z + h12.x * d2_48.z + h12.y * d2_49.z + h12.z * d2_50.z + h12.w * d2_51.z + h13.x * d2_52.z + h13.y * d2_53.z + h13.z * d2_54.z + h13.w * d2_55.z + h14.x * d2_56.z + h14.y * d2_57.z + h14.z * d2_58.z + h14.w * d2_59.z + h15.x * d2_60.z + h15.y * d2_61.z + h15.z * d2_62.z + h15.w * d2_63.z + d2_64.z;

    return clamp(vec4(y0, y1, y2, 1.0), 0.0, 1.0);
}
