shader_type canvas_item;

uniform float blur : hint_range(0, 10) = 2.0;
uniform float darkness : hint_range(0, 1) = 0.5;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

const float pi = 3.14159265359;

void gaussian_weights(float sigma, out float weights[5]) {
    float sum = 0.0;
    for (int i = 0; i < 5; i++) {
        float x = float(i - 2);
        weights[i] = exp(-0.5 * (x * x) / (sigma * sigma)) / (sigma * sqrt(2.0 * pi));
        sum += weights[i];
    }
    for (int i = 0; i < 5; i++) {
        weights[i] /= sum;
    }
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 resolution = vec2(textureSize(SCREEN_TEXTURE, 0));
    
    float weights[5];
    gaussian_weights(blur, weights);

    vec4 color = vec4(0.0);
    float total = 0.0;

    // Horizontal pass
    for (int x = -2; x <= 2; x++) {
        vec2 offset = vec2(float(x) * blur / resolution.x, 0.0);
        vec4 sample = texture(SCREEN_TEXTURE, uv + offset);
        float weight = weights[abs(x)];
        color += sample * weight;
        total += weight;
    }

    color /= total;

    vec4 final_color = vec4(0.0);
    total = 0.0;

    // Vertical pass
    for (int y = -2; y <= 2; y++) {
        vec2 offset = vec2(0.0, float(y) * blur / resolution.y);
        vec4 sample = texture(SCREEN_TEXTURE, uv + offset);
        float weight = weights[abs(y)];
        final_color += sample * weight;
        total += weight;
    }

    final_color /= total;
    final_color.rgb *= (1.0 - darkness); // Apply darkness
    COLOR = final_color;
}
