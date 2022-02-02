// ===============
// == Constants ==
// ===============

// Number of pixels between the screen edge and the content.
final int PADDING = 100;

// The maximum and minimum size of a particle.
final float MAX_POINT_SIZE = 1;
final float MIN_POINT_SIZE = 1;

// Number of particles that will follow one single path.
final int NUMBER_OF_PARTICLES_PER_PATH = 40;

// Number of paths in total.
final int NUMBER_OF_PATHS = 3000;

// Time step
final float DELTA_TIME = 0.1;

// Number of steps for each paths
final int NUMBER_OF_STEPS = 500;


// ===============
// == Variables ==
// ===============

Path[] paths = new Path[NUMBER_OF_PATHS];


// ===============
// == Functions ==
// ===============

// Definition of the flow field. Will return a vector for the given X and Y coordinates
// inidicating the direction of the field for that position.
PVector field(float x, float y) {
    // Returns a simple vertical vector, facing down.
    return new PVector(0, 15);
}

// Updates all paths in the array for a new step
void updateAllPaths() {
    for (int i = 0; i < NUMBER_OF_PATHS; i++) {
        paths[i].update();
    }
}

void setup(){
    size(500, 800);

    // Call the motion blur and gif recorder's setup function.
    setup_();

    // Configure the recording and debugging options
    recording = false;
    debugging = true;

    // Initialize the paths array.
    for (int i = 0; i < NUMBER_OF_PATHS; i++) {
        paths[i] = new Path();
    }

    // Computation of each steps for each path (will generate the array of positions
    // contained in each path)
    for (int i = 0; i < NUMBER_OF_STEPS; i++) {
        println("Computing step", i + 1, "of", NUMBER_OF_STEPS);
        updateAllPaths();
    }
}
 
void draw_(){
    background(0);
 
    // Draw the particles for each path in the array at the current time
    for (int i = 0; i < NUMBER_OF_PATHS; i++) {
        paths[i].show();
    } 
}
