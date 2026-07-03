shader_type canvas_item;

// СЮДА ДВИЖОК АВТОМАТИЧЕСКИ ПОДСОЕНЯЕТ СНИМОК ЭКРАНА ПОСЛЕ BACKBUFFERCOPY
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;

// Настройки искажения
uniform float distortion_strength : hint_range(-2.0, 2.0) = -0.3; 
uniform float radius_scale : hint_range(0.1, 3.0) = 1.0;          
uniform float zoom : hint_range(0.5, 2.0) = 1.0;                  
uniform bool clip_edges = false;                                  

void fragment() {
    vec2 uv = UV - 0.5;
    uv.x *= radius_scale; 

    float r2 = dot(uv, uv);
    
    vec2 distorted_uv = uv * (1.0 + distortion_strength * r2);
    
    distorted_uv.x /= radius_scale;
    distorted_uv = distorted_uv * zoom + 0.5;
    
    if (clip_edges && (distorted_uv.x < 0.0 || distorted_uv.x > 1.0 || distorted_uv.y < 0.0 || distorted_uv.y > 1.0)) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    } else {
        // МЕНЯЕМ TEXTURE НА SCREEN_TEXTURE, ЧТОБЫ ИСКАЖАТЬ ВЕСЬ ЭКРАН ИГРЫ С ИНТЕРФЕЙСОМ
        COLOR = texture(SCREEN_TEXTURE, distorted_uv);
    }
}