#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

[[stitchable]] float2 particlesFlow(
    float2 position,
    float time,
    float progress,
    float2 size,
    texture2d<float, access::sample> flowMap
) {
    constexpr sampler s(address::clamp_to_edge);
    float2 uv = position / size;
    float2 flow = flowMap.sample(s, uv).rg;
    
    // Displacement amplitude
    float amplitude = size.y;

    // Calculate distance to nearest edge
    float distanceToEdge = min(min(position.x, size.x - position.x), min(position.y, size.y - position.y));
    
    // Smooth fade in range [0..fadeRadius]
    const float fadeRadius = size.y/2;//amplitude/2;//30.0;
    float edgeFade = smoothstep(0.0, fadeRadius, distanceToEdge);
    
    // Combine progress + fade factor
    float finalFactor = progress * edgeFade;

    // Apply displacement
    position.x += (flow.x - 0.5) * amplitude * sin(time) * finalFactor;
    position.y += (flow.y - 0.5) * amplitude * cos(time) * finalFactor;
    
    return position;
}
