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

layout(binding = 0) uniform Model {
	mat4 mv;
	mat4 n;
} model;

layout(binding = 1) uniform View {
	mat4 vp;
} view;

void main() {
    fragPos = vec3(model.mv * vec4(pos, 1.0));
	fragColor = color;
	fragNormal = vec3(model.n * vec4(normal, 1.0));
	gl_Position = (model.mv * view.vp) * vec4(pos, 1.0);
}

