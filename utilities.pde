// Easing functions

// Simple one parameter easing function, will always output the same easing curve
float ease(float p) {
    return (3 * p * p) - (2 * p * p * p);
}

// Increasing the G value here will result into more easing (= steeper easing curve)
float ease(float p, float g) {
    if (p < 0.5) {
        return 0.5 * pow(2 * p, g);
    } else {
        return 1 - 0.5 * pow(2 * (1 - p), g);
    }
}



// Utility function to avoid having to call pushMatrix() and pushStyle() everytime.
void push() {
    pushMatrix();
    pushStyle();
}

// Utility function to avoid having to call popMatrix() and popStyle() everytime.
void pop() {
    popStyle();
    popMatrix();
}