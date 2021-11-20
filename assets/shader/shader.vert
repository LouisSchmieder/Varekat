#version 450

out gl_PerVertex {
    vec4 gl_Position;
};

layout(location = 0) in vec3 pos;
layout(location = 1) in vec3 color;

layout(location = 0) out vec3 fragColor;

layout(binding = 0) uniform UBO {
    mat4 model;
    mat4 projection;
} ubo;



vec3 getProjectedPosition(vec3 p) {
    vec4 tmp_pos = vec4(p, 1);
    tmp_pos *= ubo.model;
    tmp_pos *= ubo.projection;
    vec3 ret = vec3(tmp_pos.x, tmp_pos.y, tmp_pos.z);
    if (tmp_pos.w != 0) {
        ret /= tmp_pos.w;
    }
    return ret;
}

void main() {
    gl_Position = vec4(getProjectedPosition(pos), 1);
    fragColor = color;
}

