// Star class for background
class Star {
  float x, y;
  float size;
  float brightness;
  float twinkleSpeed;
  
  Star() {
    x = random(width);
    y = random(height);
    size = random(1, 3);
    brightness = random(150, 255);
    twinkleSpeed = random(0.02, 0.05);
  }
  
  void display() {
    fill(brightness);
    noStroke();
    ellipse(x, y, size, size);
  }
  
  void twinkle() {
    brightness += sin(frameCount * twinkleSpeed) * 10;
    brightness = constrain(brightness, 150, 255);
  }
}

// Planet class for background
class Planet {
  float x, y;
  float size;
  color planetColor;
  boolean hasRings;
  float ringAngle;
  
  Planet() {
    x = random(width);
    y = random(height/2);
    size = random(20, 40);
    planetColor = color(random(100, 255), random(100, 255), random(100, 255), 200);
    hasRings = random(1) > 0.5;
    ringAngle = random(TWO_PI);
  }
  
  void display() {
    noStroke();
    fill(planetColor);
    ellipse(x, y, size, size);
    
    // Draw planet rings if this planet has them
    if (hasRings) {
      noFill();
      stroke(planetColor, 150);
      strokeWeight(2);
      pushMatrix();
      translate(x, y);
      rotate(ringAngle);
      ellipse(0, 0, size * 1.8, size * 0.5);
      popMatrix();
    }
  }
}