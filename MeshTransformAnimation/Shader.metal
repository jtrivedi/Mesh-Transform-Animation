//
//  Shader.metal
//  MeshTransformAnimation
//
//  Created by Janum Trivedi on 12/30/23.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>

using namespace metal;

/*
 Linearly interpolates `value` from its original range `(inMin, inMax)` to a new range `(outMin, outMax)`
 ex. mapRange(0.5, 0, 1, 10, 20) = 15
 */
float mapRange(float value, float inMin, float inMax, float outMin, float outMax) {
    return ((value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin);
}

[[ stitchable ]] float2 distortion(float2 position, float4 bounds, float progress) {
    float2 size = float2(bounds[2], bounds[3]);

    // Normalize the current pixel position to a [0, 1] range.
    float2 p = position / size;

    // Pixels that are further away from the horizontal center should compress more.
    // The last two values `-1.0` and `1.0` control the amount of compression.
    float xOffset = mapRange(p.x - 0.5, -0.5, 0.5, -1.0, 1.0);

    // Adjust the horizontal compression based on the pixel's y-coordinate.
    // This creates the asymmetric "squeeze" effect.
    xOffset *= (1.0 - p.y);

    // `xOffset` is normalized from [0, 1], so multiply it by the view's width to convert back to screen coordinates.
    float xOffsetDenormalized = xOffset * size.x;

    // Move card up and down based on the animation's `progress`.
    // When progress is 0, `yOffsetDenorm` is 0. When progress = 1, the translation is slightly larger than the screen's height.
    float yOffsetDenorm = size.y * 1.3 * progress;

    // De-normalize back to screen coordinates again.
    xOffsetDenormalized *= progress;

    // Return our adjusted coordinate for this pixel.
    return float2(position.x + xOffsetDenormalized, position.y + yOffsetDenorm);
}
