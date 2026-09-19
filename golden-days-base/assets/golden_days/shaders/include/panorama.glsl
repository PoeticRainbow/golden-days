// Golden Days
// PoeticRainbow

const float DEGREES_180 = radians(180.0);
const vec3 X_AXIS = vec3(1.0, 0.0, 0.0);
const vec3 Y_AXIS = vec3(0.0, 1.0, 0.0);

mat4 rotate3d(float angle, vec3 axis) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float oc = 1.0 - c;

  return mat4(
    oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
    oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
    oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,          0.0,
    0.0,                               0.0,                               0.0,                               1.0
  );
}

mat4 createPanoramaViewMat(mat4 modelViewMat) {
    // TODO: fix the jitter when full loop since it does not loop cleanly
    // TODO: figure out why gametime doesn't work

    // have to create the view matrix from scratch since the tilt must be done before the spin

    // beta 1.8 (this.field_35357_f is current time in ticks, var3 is tickDelta)
    float progress = atan(modelViewMat[0][2], modelViewMat[0][0]);

    // rotate right size up and then rotate around to front
    mat4 panoramaViewMat = rotate3d(DEGREES_180, vec3(0.0, 0.0, 1.0)) * rotate3d(DEGREES_180, Y_AXIS);
    // rotate up and down 25 degrees from 20 degrees
    // GL11.glRotatef(MathHelper.sin(((float)this.field_35357_f + var3) / 400.0F) * 25.0F + 20.0F, 1.0F, 0.0F, 0.0F);
    panoramaViewMat *= rotate3d(sin(progress * 10.0 * 0.0025) * radians(25.0) - radians(20.0), X_AXIS);
    // rotate with time around y axis
    // GL11.glRotatef(-((float)this.field_35357_f + var3) * 0.1F, 0.0F, 1.0F, 0.0F);
    panoramaViewMat *= rotate3d(-progress, Y_AXIS);

    return modelViewMat;
}
