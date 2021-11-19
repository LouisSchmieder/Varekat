#version 450

out gl_PerVertex {
    vec4 gl_Position;
};

layout(location = 0) in vec3 pos;
layout(location = 1) in vec3 color;

layout(location = 0) out vec3 fragColor;

layout(binding = 0) uniform UBO {
    mat4 mvp;
} ubo;

void main() {
    gl_Position = ubo.mvp * vec4(pos, 1);
    fragColor = color;
}