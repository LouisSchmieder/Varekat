#version 450

out gl_PerVertex {
    vec4 gl_Position;
};

layout(location = 0) in vec3 pos;
layout(location = 1) in vec3 color;
layout(location = 2) in vec3 normal;

layout(location = 0) out vec3 fragColor;
layout(location = 1) out vec3 fragNormal;
layout(location = 2) out vec3 fragPos;

layout(binding = 0) uniform UBO {
    mat4 model;
    mat4 view;
    mat4 projection;
    vec3 lightPosition;
    vec4 lightColor;
} ubo;

vec3 getProjectedPosition(vec3 p) {
    vec4 tmp_pos = vec4(p, 1);
    tmp_pos *= ubo.model;
    tmp_pos *= ubo.view;
    tmp_pos *= ubo.projection;
    vec3 ret = vec3(tmp_pos.x, tmp_pos.y, tmp_pos.z);
    if (tmp_pos.w != 0) {
        ret /= tmp_pos.w;
    }
    return ret;
}

void main() {
    gl_Position = vec4(getProjectedPosition(pos), 1);

    fragPos = vec3(ubo.model * vec4(pos, 1));
    fragColor = color;
    fragNormal = normal;
}

