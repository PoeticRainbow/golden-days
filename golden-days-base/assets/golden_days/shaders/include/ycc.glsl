// RGB to YCbCr, ranges [0, 1]
vec3 rgb2ycc(vec3 rgb) {
    float y = 0.299 * rgb.r + 0.587 * rgb.g + 0.114 * rgb.b;
    float cb = (rgb.b - y) * 0.565;
    float cr = (rgb.r - y) * 0.713;

    return vec3(y, cb, cr);
}

// YCbCr to RGB
vec3 ycc2rgb(vec3 yuv) {
    return vec3(
        yuv.x + 1.403 * yuv.z,
        yuv.x - 0.344 * yuv.y - 0.714 * yuv.z,
        yuv.x + 1.770 * yuv.y
    );
}