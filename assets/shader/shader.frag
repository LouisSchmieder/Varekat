#version 450

layout(location = 0) in vec3 fragColor;
layout(location = 1) in vec3 fragNormal;
layout(location = 2) in vec3 fragPos;

layout(location = 0) out vec4 outColor;
 
const vec3 lightColor = vec3(1, 1, 1);
const float ambient_strenght = 0.1;
const vec3 lightPos = vec3(0, 0, 1);

void main() {

    vec3 ambient = ambient_strenght * lightColor;
    
    vec3 norm = normalize(fragNormal);
    vec3 lightDir = normalize(lightPos - fragPos);
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = diff * lightColor;
    vec3 result = (ambient * diff) * fragColor;
    outColor = vec4(result, 1.0);
}