shader_type canvas_item;

// Настройки искажения
uniform float distortion_strength : hint_range(-2.0, 2.0) = -0.3; // Отрицательные значения делают эффект "шлема"
uniform float radius_scale : hint_range(0.1, 3.0) = 1.0;          // Насколько круглый эффект (вытягивание по осям)
uniform float zoom : hint_range(0.5, 2.0) = 1.0;                  // Компенсация размера (чтобы интерфейс не уезжал)
uniform bool clip_edges = false;                                  // Отсекать ли черные края, если искажение выходит за рамки

void fragment() {
    // Центрируем UV и корректируем пропорции (делаем круглым/овальным через radius_scale)
    vec2 uv = UV - 0.5;
    uv.x *= radius_scale; 

    float r2 = dot(uv, uv);
    
    // Формула искажения. Мягко деформирует края
    vec2 distorted_uv = uv * (1.0 + distortion_strength * r2);
    
    // Возвращаем пропорции назад и масштабируем (zoom), чтобы удержать интерфейс в экране
    distorted_uv.x /= radius_scale;
    distorted_uv = distorted_uv * zoom + 0.5;
    
    // Проверка границ (вынесена в uniform-переключатель)
    if (clip_edges && (distorted_uv.x < 0.0 || distorted_uv.x > 1.0 || distorted_uv.y < 0.0 || distorted_uv.y > 1.0)) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    } else {
        COLOR = texture(TEXTURE, distorted_uv);
    }
}