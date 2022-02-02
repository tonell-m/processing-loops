// ===============
// == Constants ==
// ===============

// Number of pixels between the screen edge and the content.
final int PADDING = 50;

// The maximum and minimum size of a particle.
final float MAX_POINT_SIZE = 0.5;
final float MIN_POINT_SIZE = 1.5;

// Number of particles that will follow one single path.
final int NUMBER_OF_PARTICLES_PER_PATH = 10;

// Number of paths in total.
final int NUMBER_OF_PATHS = 3000;

// Time step
final float DELTA_TIME = 0.1;

// Number of steps for each paths
final int NUMBER_OF_STEPS = 100;

// Enable this to draw a white rect around the borders
final boolean DRAW_BORDERS = true;


// ===============
// == Variables ==
// ===============

Path[] paths = new Path[NUMBER_OF_PATHS];
Field field = new CombinedKampyleSuperForumlaField(1, 1, 3, 0, 0);

long seed = 0;


// ===============
// == Functions ==
// ===============

// Updates all paths in the array for a new step
void updateAllPaths() {
    for (int i = 0; i < NUMBER_OF_PATHS; i++) {
        paths[i].update();
    }
}

long getNewSeed() {
    // Returns a seed that can be accepted by randomSeed and noiseSeed,
    // generated based on system time so that it is never the same.
    return floor(System.nanoTime() / 100000);
}

void setupPaths() {
    // Regenerate a new seed everytime.
    seed = getNewSeed();
    randomSeed(seed);
    noiseSeed(seed);

    println("- - - - Start generating with seed", seed, "- - - -");

    // Initialize the paths array.
    for (int i = 0; i < NUMBER_OF_PATHS; i++) {
        paths[i] = new Path(field);
    }

    // Computation of each steps for each path (will generate the array of positions
    // contained in each path)
    for (int i = 0; i < NUMBER_OF_STEPS; i++) {
        println("Computing step", i + 1, "of", NUMBER_OF_STEPS);
        updateAllPaths();
    }

    println("- - - - Done generating with seed", seed, " - - - -");
}

void setup(){
    size(500, 500);

    // Call the motion blur and gif recorder's setup function.
    setup_();

    // Initialize and compute the paths
    setupPaths();

    // Configure the recording and debugging options
    recording = false;
    debugging = true;
}
 
void draw_(){
    background(0);
 
    // Draw the particles for each path in the array at the current time
    for (int i = 0; i < NUMBER_OF_PATHS; i++) {
        paths[i].show(t);
    }

    if (DRAW_BORDERS) {
        strokeWeight(1.0);
        stroke(255);
        noFill();
        rect(PADDING, PADDING, width - 2 * PADDING, height - 2 * PADDING);
    }
}

void mousePressed() {
    setupPaths();
}
