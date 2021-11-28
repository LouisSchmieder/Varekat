#version 450

out gl_PerVertex {
	vec4 gl_Position;
};

layout(location = 0) in vec3 pos;
layout(location = 1) in vec3 color;
layout(location = 2) in vec3 normal;

layout(location = 0) out vec3 fragColor;

layout(binding = 0) uniform UBO {
	mat4 model;
	mat4 view;
	mat4 projection;
	vec3 lightPosition;
	vec4 lightColor;
} ubo;

void main() {
    gl_Position = vec4(pos, 1) * ubo.model * ubo.view * ubo.projection;

    fragColor = color;
}

