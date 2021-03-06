#version 300 es
precision mediump float;

#define SCREEN 0
#define DODGE 1
#define BURN 2
#define OVERLAY 3
#define MULTIPLY 4
#define ADD 5
#define DIVIDE 6
#define GRAIN_EXTRACT 7
#define GRAIN_MERGE 8

// grayscale
uniform sampler2D t_Lena;
// rgba
uniform sampler2D t_Tint;

uniform int i_Blend;

in vec2 v_Uv;
out vec4 Target0;

void main() {
    // we sample from both textures using the same uv coordinates. since our
    // lena image is grayscale, we only get the first component.
    vec3 lena = vec3(texture(t_Lena, v_Uv).r);
    vec3 tint = texture(t_Tint, v_Uv).rgb;

    vec3 result = vec3(0.0);

    // normally you'd have a shader program per technique, but for the sake of
    // simplicity we'll just branch on it here.
    switch (i_Blend) {
        case SCREEN:
            result = vec3(1.0) - ((vec3(1.0) - lena) * (vec3(1.0) - tint));
            break;
        case DODGE:
            result = lena / (vec3(1.0) - tint);
            break;
        case BURN:
            result = vec3(1.0) - ((vec3(1.0) - lena) / lena);
            break;
        case OVERLAY:
            result = lena * (lena + (tint * 2.0) * (vec3(1.0) - lena));
            break;
        case MULTIPLY:
            result = lena * tint;
            break;
        case ADD:
            result = lena + tint;
            break;
        case DIVIDE:
            result = lena / tint;
            break;
        case GRAIN_EXTRACT:
            result = lena - tint + 0.5;
            break;
        case GRAIN_MERGE:
            result = lena + tint - 0.5;
            break;
    }

    Target0 = vec4(result, 1.0);
}
