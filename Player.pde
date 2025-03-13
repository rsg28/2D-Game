// Player class
class Player {
  float x, y;
  float size = 30;
  float speed = 5;
  int health = 100;
  boolean movingLeft, movingRight, movingUp, movingDown;
  float engineFlickerRate = 0.2;
  
  Player(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void update() {
    if (movingLeft) x -= speed;
    if (movingRight) x += speed;
    if (movingUp) y -= speed;
    if (movingDown) y += speed;
    
    // Keep player in bounds
    x = constrain(x, size/2, width - size/2);
    y = constrain(y, height/2, height - size/2);
    
    // Create engine particle effects
    if (frameCount % 3 == 0) {
      particles.add(new Particle(x, y + size/2, color(0, 150, 255)));
    }
  }
  
  void display() {
    // Draw engine glow
    noStroke();
    float flicker = random(0.8, 1.2);
    fill(0, 150, 255, 150 * flicker);
    ellipse(x, y + size/2, size/2, size * flicker);
    
    // Draw player ship
    fill(0, 200, 255);
    triangle(x, y - size/2, x - size/2, y + size/2, x + size/2, y + size/2);
    
    // Draw cockpit
    fill(200, 255, 255);
    ellipse(x, y, size/3, size/3);
    
    // Draw health bar
    noStroke();
    fill(100, 100, 100);
    rect(x - size/2, y - size - 10, size, 5);
    fill(255 * (1 - health/100.0), 255 * (health/100.0), 0);
    rect(x - size/2, y - size - 10, size * (health / 100.0), 5);
  }
  
  void shoot() {
    bullets.add(new Bullet(x, y - size/2, false));
    // Create muzzle flash effect
    createExplosion(x, y - size/2, 3, color(0, 255, 255));
  }
}