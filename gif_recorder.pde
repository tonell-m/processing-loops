// =================
// === Constants ===
// =================

// final float mn = 0.5 * sqrt(3);
// final float ia = atan(sqrt(0.5));


// ======================
// == Config variables ==
// ======================

// Enable this to actually save the frames into png files.
boolean recording = false;

// Enable this to disable motion blur and control the gif's execution using the mouse position in the canvas.
boolean debugging = false;

// Number of drawings that are used to produce a single frame.
// The outputed frame will be an average of them for motion blur. A higher value increases the quality
// of the motion blur but will take more time to compute.
int samplesPerFrame   = 5;

// Number of frames the gif will contain in total.
int numFrames         = 50;

// controls how spaced in time the samples of each frames are. If shutterAngle is equal to 1.0, the last sample of a frame will
// be just before the first sample of the next frame. If it is greater than 1.0, the samples of each frame will overlap in time
// with the samples of the neighboring frames. If it is smaller than 1.0 it will be more separated.
float shutterAngle    = 0.9;


// =====================================
// == Shared properties for computing ==
// =====================================

// Contains the sum of the samples for one frame that will be used to compute the motion blur.
int[][] result;

float t, c;


// ===============
// == Functions ==
// ===============

// Performs setup code needed for the gif recorder and motion blur execution.
// Needs to be called after size(x, y) in Processing's setup function.
void setup_() {
    // The three channels in this array are used to store the RGB components of each pixels.
    result = new int[width * height][3];
}

// Processing's draw function.
// IMPORTANT: Take care that when “draw_()” is called once again, the coordinate changes that you may have done with something like
// “translate” are not reset because it’s not the real “draw()”. You have to use “push()” and “pop()” around your coordinate changes.
void draw() {
    
    if (debugging) {
        // If debugging is enabled, the mouse position on the x axis sets the t value (left is 0, right is 1)
        // This allows easier debugging of the gif without actually exporting the frames. The motion blur will not
        // work in that case however.
        t = mouseX * 1.0 / width;
        c = mouseY * 1.0 / height;
        draw_();
    } else {
        // If recording is enabled, play each frame by calling the draw_() function and apply motion blur before
        // saving each frame into a separate png file.
        for (int i = 0; i < width * height; i++) {
            for (int a = 0; a < 3; a++) {
                result[i][a] = 0;
            }
        }
        c = 0;
        for (int sa = 0; sa < samplesPerFrame; sa++) {
            // Compute the t value for this sample, based on shutterAngle, numFrames and samplesPerFrame.
            // Using modulo 1 here allows t never to exceed 1 so that when we're not recording the t value will
            // always cycle between 0 and one.
            t = map(frameCount - 1 + sa * shutterAngle / samplesPerFrame, 0, numFrames, 0, 1) % 1.0;
            // Call the actual draw function.
            draw_();
            
            // Read the pixels currently displayed in the canvas and load them in the result array.
            loadPixels();
            for (int i = 0; i < pixels.length; i++) {
                result[i][0] += pixels[i] >> 16 & 0xff;
                result[i][1] += pixels[i] >> 8 & 0xff;
                result[i][2] += pixels[i] & 0xff;
            }
        }
        
        // Load the currently displayed pixels, feed the pixels array with the current result buffer and display that on the canvas.
        loadPixels();
        for (int i = 0; i < pixels.length; i++)
            pixels[i] = 0xff << 24 | 
            int(result[i][0] * 1.0 / samplesPerFrame) << 16 | 
            int(result[i][1] * 1.0 / samplesPerFrame) << 8 | 
            int(result[i][2] * 1.0 / samplesPerFrame);
        updatePixels();
        
        if (recording) {
            // Save the current frame inside a png file.
            saveFrame("fr###.png");
            println(frameCount, "/", numFrames);
        }
        
        // If we're recording and the total number of frames has been reached, terminate the program.
        if (recording && frameCount == numFrames) {
            exit();
        }
    }
}
