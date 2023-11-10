
// This class represents a path followed by particles in a flow field
class Path {
    
    // - Properties

    // Particle size when drawing
    private final float size = random(MIN_POINT_SIZE, MAX_POINT_SIZE);

    // Number of particles per path
    private final int particlesCount = NUMBER_OF_PARTICLES_PER_PATH;
    
    // X,Y position
    private float x = random(width);
    private float y = random(height);
    
    // Positions history stored in an array for drawing
    private ArrayList<PVector> positions = new ArrayList<PVector>();

    // Random time offset so that particles don't appear at the same time for each path
    private float timeOffset = random(1);

    private Field field;


    // - Lifecycle

    Path(Field field) {
        this.field = field;

        // Initialize the positions array with the initial position.
        positions.add(new PVector(x, y));
    }


    // - Public functions

    // Computes the next position of particles in this path
    void update() {
        // Get the direction vector in the field for the current coordinates
        PVector direction = field.get(x, y);

        // Multiply that direction with the time factor and add it to the current position
        x += DELTA_TIME * direction.x;
        y += DELTA_TIME * direction.y;

        // Add the obtained position to the positions array
        positions.add(new PVector(x, y));
    }

    // Draw the particles in this path on the canvas for a given time value
    void show(float time) {
        strokeWeight(size);

        float offsettedTime = (time + timeOffset) % 1.0;
        int len = positions.size();

        for (int i = 0; i < particlesCount; i++) {
            // Get the location of the position for the given particle in the array
            // The map function here maps the particle value plus the current time to 
            // a position in the array
            float location = constrain(
                map(i + offsettedTime, 0, particlesCount, 0, len - 1),
                0,
                len - 1 - 0.001
            );

            int positionIndex = floor(location);
            int nextPositionIndex = positionIndex + 1;

            // The amount to be passed to the lerp function based on the difference 
            // between the nearest position found and the actual precise location
            // (between previous and next positions)
            float lerpAmount = location - floor(location);
            
            // Calculate the particle's X,Y coordinates using linear interpolation between
            // the two nearest positions, using the amount computed just above.
            float particleX = lerp(
                positions.get(positionIndex).x,
                positions.get(nextPositionIndex).x,
                lerpAmount
            );
            float particleY = lerp(
                positions.get(positionIndex).y,
                positions.get(nextPositionIndex).y,
                lerpAmount
            );

            // If the particle is outside the bounds of the screen (minus the padding), don't draw it
            if (particleX < PADDING || particleX > width - PADDING ||
                particleY < PADDING || particleY > height - PADDING) {
                continue;
            }

            // This makes the particles appear and disappear gradually
            float alpha = 255 * pow(sin(PI * location / (len - 1)), 0.25);

            stroke(255, alpha);

            // Draw the particle in the canvas at the computed coordinates.
            point(particleX, particleY);
        }
    }
}