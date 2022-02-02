
// Interface defining an abstract flow field.
// The get(x, y) function should return the direction of the path
// following this field for given coordinates.
interface Field {
    PVector get(float x, float y);
}


// Simple implementation of a vertical flow field, facing down.
// The intensity parameter corresponds to the strength of the returned vector.
// This implementation will always return a fixed vector, regardless of the given coordinates.
class VerticalField implements Field {

    // - Properties

    private final float intensity;


    // - Lifecycle

    VerticalField(float intensity) {
        this.intensity = intensity;
    }


    // - Field

    PVector get(float x, float y) {
        return new PVector(0, intensity);
    }
}


// Classic perlin noise implementation that will return a vector with a direction based
// on the sampled noise value for the given coordinates, affected by the given scale, amount
// and biases parameters
class PerlinNoiseField implements Field {

    // - Properties

    // Intensity of the noise on the returned vector.
    protected final float amount;

    // Scale to apply to the noise function (the greater the scale, the larger the noise)
    protected final float scale;

    // Horizontal bias applied to the output vector direction.
    // Increasing this value will give a flowing impression from left to right
    protected final float horizontalBias;

    // Vertical bias applied to the output vector direction.
    // Increasing this value will give a flowing impression from top to bottom
    protected final float verticalBias;


    // - Lifecycle

    PerlinNoiseField(float amount, float scale, float hBias, float vBias) {
        this.amount = amount;
        this.scale = scale;
        this.horizontalBias = hBias;
        this.verticalBias = vBias;
    }

    PerlinNoiseField() {
        this(50, 0.03, 20, 0);
    }


    // - Field

    PVector get(float x, float y) {
        return new PVector(
            amount * (noise(scale * x, scale * y) - 0.5) + horizontalBias,
            amount * (noise(scale * x, scale * y) - 0.5) + verticalBias
        );
    }
}


// Subclass of PerlinNoiseField that will use cos and sine functions to determine the direction
// of the vector at the given coordinates based on the sample noise value at that position,
// giving a circular-like impression to the field
class CircularPerlinNoiseField extends PerlinNoiseField {

    // - Properties

    // This parameter will affect the size of the "circles" outputed by this approach.
    // Higher values will result in smaller circles while smaller values will result in
    // bigger circles.
    private final float circleStrength;


    // - Lifecycle

    CircularPerlinNoiseField(float amount, float scale, float circleStrength) {
        // Horizontal and vertical biases don't really make sense in this scenario so
        // their values are defaulted to 0.
        super(amount, scale, 0, 0);
        this.circleStrength = circleStrength;
    }

    CircularPerlinNoiseField() {
        this(50, 0.01, 25, 0, 0);
    }


    // - Field

    @Override
    PVector get(float x, float y) {
        float noiseValue = circleStrength * noise(scale * x, scale * y);
        return new PVector(
            amount * cos(noiseValue),
            amount * sin(noiseValue)
        );
    }
}