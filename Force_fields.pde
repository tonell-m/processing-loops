// ===============
// == Constants ==
// ===============

// Number of dots that will be instantiated.
final int n = 3000;

// Number of pixels between the screen edge and the content.
final int padding = 100;


// =============
// == Classes ==
// =============

class Dot {

    // - Properties

    float x = random(padding, width - padding);     // Initial X position
    float y = random(padding, height - padding);    // Initial Y position
    float radius = random(2, 15);                   // Radius of the circle in which the dot will move
    float size = random(1, 2.5);                    // Size of the dot

    // Initial offset in the dot's rotation. This avoids having all the dots at the same angle at the same time.
    // Using a noise function here instead of a random value allows for a more pattern-like result.
    float offset = 9 * noise(0.02 * x, 0.02 * y);

    
    // - Public functions

    void show() {
        stroke(255, 200);
        strokeWeight(size);

        float easedTime = ease(t, 1.1);
        point(
            x + radius * cos(TWO_PI * easedTime + offset),
            y + radius * sin(TWO_PI * easedTime + offset)
        );
    }
}


// ===============
// == Functions ==
// ===============

// Array of dots to animate.
Dot[] array = new Dot[n];

void setup(){
    size(500, 800);

    // Call the motion blur and gif recorder's setup function.
    setup_();

    // Configure the recording and debugging options
    recording = false;
    debugging = false;

    // Initialize the dot array.
    for (int i = 0; i < n; i++) {
        array[i] = new Dot();
    }
}
 
void draw_(){
    background(0);
 
    // Draw each dot present in the array.
    for (int i = 0; i < n; i++) {
        array[i].show();
    } 
}
