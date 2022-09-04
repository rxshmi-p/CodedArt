/** Assignment 3 - Rashmi Panse , 400178788
My keywords are trippy and elusive 
Credit for inspiration: https://020406.org/processing/pde/DeformGridWithMouse.pde
I have commented lines with "ADDED", "CHANGED", and "REMOVED" to specify parts of the code.
*/

 
//Main array variables used for grid shifting 
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<ArrayList<PVector>> grid = new ArrayList<ArrayList<PVector>>();
// Boolean variable set to False
boolean attract = false;
// Graphics variable, to load grid image 
PGraphics pg;

// Initializing variables for pointer 
int num = 60;
float mx[] = new float[num];
float my[] = new float[num];
// Initializing variables for graphics
int n = 60;
int margin = 0;

// Setting up basic parameters 
void setup() {
  // CHANGED: Made window longer for stretch in grid
  //P2D rendering used for a substantially faster drawing
  size(600, 900, P2D);
  pg = createGraphics(1080, 1080, P2D);
  pg.smooth(8);
  // Creates grid background 
  float inc = (pg.width - margin * 2.0) / n;
  for (int i = -n; i <= n * 2; i++) {
    ArrayList<PVector> list = new ArrayList<PVector>();
    float y = margin + i * inc;
    // CHANGED: multiplied n * 5 for closers lines to add to elusive feeling
    for (int j = -n; j <= n * 5; j++) {
      float x = margin + j * inc;
      PVector p = new PVector(x, y);
      // Sets points of grid
      list.add(p);
      points.add(p);
    }
    // Adds lines of grids
    grid.add(list);
  }
}

// Creates function to deform grid
boolean onScreen(PVector p) {
  return p.x >= margin && p.x <= pg.width - margin && p.y >= margin && p.y <= pg.height - margin;
}

// Drawing new grid, deforming in the direction of where mouse is pressed on screen
void draw() {
  if (mousePressed) {
    // Attracting points towards where mouse is pressed
    // used LEFT to create inward depth in grid 
    boolean attract = mouseButton == LEFT;
    deform(points, attract);
  }
  pg.beginDraw();
  pg.background(0, 0, 75);
  pg.stroke(175, 125, 255);
  pg.strokeWeight(1.5);
  
  // ADDED: Changes background from dark to light to contribute to trippy feeling
  if (mouseX > 300) {
     background(213, 240, 251);
  }
  
  for (int j = 0; j < grid.size() - 1; j++) {
    ArrayList<PVector> row = grid.get(j);
    for (int i = 0; i < row.size() - 1; i++) {
      PVector p = row.get(i);
      PVector p2 = row.get(i + 1);
      PVector p3 = grid.get(j + 1).get(i);
      if (onScreen(p) || onScreen(p2) || onScreen(p3)) {
        pg.line(p.x, p.y, p2.x, p2.y);
        pg.line(p.x, p.y, p3.x, p3.y);
      }
    }
  }
  for (PVector p : points) {
    if (onScreen(p)) {
      pg.point(p.x, p.y);
    }
  }
  pg.noStroke();
  pg.fill(255, 200, 200);
  pg.circle(map(mouseX, 0, width, 0, pg.width), map(mouseY, 0, height, 0, pg.height), 16);
  pg.endDraw();
  image(pg, 0, 0, width, height);
  println(frameCount);
  //REMOVED: used drawn grid instead of picture
  //if (frameCount == 1800) {
  //  saveFrame("output.png");
  //}
  
  
 //ADDED: Storing Input. As mouse moves across the screen positions of the mouse are recorded into an array and played back every frame. 
 //Between each frame, the newest value are added to the end of each array and the oldest value is deleted
  int which = frameCount % num; // Cycles through the array, using a different entry on each frame. Using modulo works faster than moving all values over
  mx[which] = mouseX;//ADDED: circle pointer that follows mouse
  my[which] = mouseY;
  
  for (int i = 0; i < num; i++) {
    // which+1 is the smallest (the oldest in the array)
    int index = (which+1 + i) % num;
    fill(#CBC3E3, 90); //ADDED: Purple colour to ellipse pointer & added transparency 
    //CHANGED: made tail of pointer longer 
    ellipse(mx[index]-25, my[index]-25, i, i);
  }
}

// Function to perform deforming of points
// Points attract towards area where mouse is pressed, then grid is deformed to match points 
void deform(ArrayList<PVector> set, boolean attract) {
  PVector c = new PVector(map(mouseX, 0, width, 0, pg.width), map(mouseY, 0, height, 0, pg.height)); // new PVector(width / 2, height / 2);
  float maxDiagonal = getMaxDist(c, set); // dist(margin, margin, width / 2, height / 2);
  for (PVector p : set) {
    float d = dist(p.x, p.y, c.x, c.y);
    float dFactor = attract ? 1 - 0.03 * pow(1 - d / maxDiagonal, 15) : 1 + 0.03 * pow(1 - d / maxDiagonal, 15);
    PVector temp = p.copy();
    temp.sub(c);
    temp.mult(dFactor);
    temp.add(c);
    p.x = temp.x;
    p.y = temp.y;
  }
}

float getMaxDist(PVector p, ArrayList<PVector> set) {
  if (set.isEmpty()) {
    return 0;
  }
  float maxDistSq = Float.MIN_VALUE;
  for (PVector v : set) {
    float dSq = v.copy().sub(p).magSq();
    if (dSq > maxDistSq) {
      maxDistSq = dSq;
    }
  }
  return sqrt(maxDistSq);
}
