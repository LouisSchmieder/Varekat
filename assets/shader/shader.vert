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

void main() {
    gl_Position = vec4(pos, 1) * ubo.model * ubo.view * ubo.projection;

	fragNormal = normal;
    fragColor = color;
	fragPos = vec3(vec4(pos, 1) * ubo.model);
}

