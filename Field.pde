
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

    // Factor applied to both components of the returned vector.
    // A higher value will mean a higher intensity.
    protected final float amount;

    // Scale to apply to the noise function, kind of like zooming in.
    // Lower values will mean a more "zoomed in" noise.
    protected final float scale;

    // Constant applied in the computation. The way this parameter is used varies from
    // one implementation to the other. See subclasses get functions for more details.
    protected final float constant;

    // Horizontal bias applied to the output vector direction.
    // Increasing this value will give a flowing impression from left to right
    protected final float horizontalBias;

    // Vertical bias applied to the output vector direction.
    // Increasing this value will give a flowing impression from top to bottom
    protected final float verticalBias;


    // - Lifecycle

    PerlinNoiseField(float amount, float scale, float constant, float hBias, float vBias) {
        this.amount = amount;
        this.scale = scale;
        this.constant = constant;
        this.horizontalBias = hBias;
        this.verticalBias = vBias;
    }

    PerlinNoiseField() {
        this(50, 0.03, 0, 20, 0);
    }


    // - Field

    PVector get(float x, float y) {
        return new PVector(
            amount * (noise(scale * x, scale * y) - 0.5) + horizontalBias,
            amount * (noise(scale * x, scale * y) - 0.5) + verticalBias
        );
    }
}


// Subclass of PerlinNoiseField that uses the same value for both X and Y components of
// the outputed vector, resulting on a 45 degrees angled noise field.
class FixedAnglePerlinNoiseField extends PerlinNoiseField {

    // - Lifecycle

    FixedAnglePerlinNoiseField(float amount, float scale, float constant, float hBias, float vBias) {
        super(amount, scale, constant, hBias, vBias);
    }

    FixedAnglePerlinNoiseField() {
        super();
    }


    // - Field

    @Override
    PVector get(float x, float y) {
        float direction = amount * (noise(scale * x, scale * y) - 0.5);
        return new PVector(direction, direction);
    }
}


// Subclass of PerlinNoiseField that will use cos and sine functions to determine the direction
// of the vector at the given coordinates based on the sample noise value at that position,
// giving a circular-like impression to the field
// In this implementation the constant parameter will affect the size of the "circles" outputed by
// this approach. Higher values will result in smaller circles while smaller values will result in
// bigger circles.
class CircularPerlinNoiseField extends PerlinNoiseField {

    // - Lifecycle

    CircularPerlinNoiseField(float amount, float scale, float constant) {
        // Horizontal and vertical biases don't really make sense in this scenario so
        // their values are defaulted to 0.
        super(amount, scale, constant, 0, 0);
    }

    CircularPerlinNoiseField() {
        this(50, 0.01, 25);
    }


    // - Field

    @Override
    PVector get(float x, float y) {
        float noiseValue = constant * noise(scale * x, scale * y);
        return new PVector(
            amount * cos(noiseValue),
            amount * sin(noiseValue)
        );
    }
}


// Computes the output the output vector using an Astroid parametric curve
// More info:
// https://generateme.wordpress.com/2016/04/24/drawing-vector-field/
// https://en.wikipedia.org/wiki/Astroid
class AstroidPerlinNoiseField extends PerlinNoiseField {

    // - Lifecycle

    AstroidPerlinNoiseField(float amount, float scale, float constant, float hBias, float vBias) {
        super(amount, scale, constant, hBias, vBias);
    }

    AstroidPerlinNoiseField() {
        this(50, 0.03, 5, 20, 0);
    }


    // - Field

    @Override
    PVector get(float x, float y) {
        float n = constant * (noise(scale * x, scale * y) - 0.5);

        float sinN = sin(n);
        float cosN = cos(n);

        return new PVector(
            amount * sq(sinN) * sinN + horizontalBias,
            amount * sq(cosN) * cosN + verticalBias
        );
    }
}


// Computes the output vector using a Kampyle of Eudoxus parametric curve
// More info:
// https://generateme.wordpress.com/2016/04/24/drawing-vector-field/
// https://en.wikipedia.org/wiki/Kampyle_of_Eudoxus
class KampyleOfEudoxusPerlinNoiseField extends PerlinNoiseField {

    // - Lifecycle

    KampyleOfEudoxusPerlinNoiseField(float amount, float scale, float constant, float hBias, float vBias) {
        super(amount, scale, constant, hBias, vBias);
    }

    KampyleOfEudoxusPerlinNoiseField() {
        this(10, 0.03, 6, 30, -30);
    }


    // - Field

    @Override
    PVector get(float x, float y) {
        float n = constant * (noise(scale * x, scale * y) - 0.5);
        float sec = 1 / sin(n);

        return new PVector(
            amount * sec + horizontalBias,
            amount * tan(n) * sec + verticalBias
        );
    }
}


// Computes the output vector using a Rectangular hyperbola parametric curve
// More info:
// https://generateme.wordpress.com/2016/04/24/drawing-vector-field/
// https://en.wikipedia.org/wiki/Hyperbola#Rectangular_hyperbola
class RectangularHyperbolaPerlinNoiseField extends PerlinNoiseField {

    // - Lifecycle

    RectangularHyperbolaPerlinNoiseField(float amount, float scale, float constant, float hBias, float vBias) {
        super(amount, scale, constant, hBias, vBias);
    }

    RectangularHyperbolaPerlinNoiseField() {
        this(40, 0.01, 10, 20, -20);
    }


    // - Field

    @Override
    PVector get(float x, float y) {
        float n = constant * (noise(scale * x, scale * y) - 0.5);
        float sec = 1 / sin(n);

        return new PVector(
            amount * sec + horizontalBias,
            amount * tan(n) + verticalBias
        );
    }
}


// Computes the output vector using a Rectangular hyperbola parametric curve
// More info:
// https://generateme.wordpress.com/2016/04/24/drawing-vector-field/
// https://en.wikipedia.org/wiki/Superformula
class SuperFormulaPerlinNoiseField extends PerlinNoiseField {

    // - Properties

    private final float a;
    private final float b;
    private final float m;
    private final float n1;
    private final float n2;
    private final float n3;


    // - Lifecycle

    SuperFormulaPerlinNoiseField(
        float amount,
        float scale,
        float constant,
        float a,
        float b,
        float m,
        float n1,
        float n2,
        float n3,
        float hBias,
        float vBias
    ) {
        super(amount, scale, constant, hBias, vBias);
        this.a = a;
        this.b = b;
        this.m = m;
        this.n1 = n1;
        this.n2 = n2;
        this.n3 = n3;
    }

    SuperFormulaPerlinNoiseField() {
        // Various constant sets that give harmonious results. Uncomment the line you want to use.
        this(20, 0.08, 5, 1, 1, 6, 1, 7, 8, 0, 0);
        // this(20, 0.1, 5, 1.3, 1.2, 6, 1, 5, 3, -10, 10);
        // this(30, 0.05, 5, 1, 1.2, 4, 2, 4, 4, -30, -30);
        // this(30, 0.05, 5, 1, 1.2, 4, 2, 4, 4, 0, 0);
        // this(30, 0.05, 5, 1, 0.9, 8, 4, 1, 7, 0, 0);
    }


    // - Field

    @Override
    PVector get(float x, float y) {
        float n = constant * (noise(scale * x, scale * y) - 0.5);
        
        float f1 = pow(abs(cos(m * n / 4) / a), n2);
        float f2 = pow(abs(sin(m * n / 4) / b), n3);
        float fr = pow(f1 + f2, -1 / n1);

        return new PVector(
            amount * cos(n) * fr + horizontalBias,
            amount * sin(n) * fr + verticalBias
        );
    }
}
