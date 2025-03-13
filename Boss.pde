// Boss class
class Boss {
  float x, y;
  float size = 80;
  float speed = 3;
  int health = 300;
  float direction = 1;  // 1 for right, -1 for left
  float angle = 0;
  
  Boss(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void update() {
    // Move side to side faster than regular enemies
    x += speed * direction;
    
    // Change direction at edges
    if (x > width - size/2 || x < size/2) {
      direction *= -1;
    }
    
    // Slight bobbing motion
    angle += 0.05;
    y = y + sin(angle) * 2;
  }
  
  void display() {
    // Draw boss ship
    fill(255, 0, 255);
    ellipse(x, y, size, size);
    
    // Draw inner details
    fill(200, 0, 200);
    ellipse(x, y, size * 0.7, size * 0.7);
    
    // Draw core
    fill(255, 255, 100);
    ellipse(x, y, size * 0.4, size * 0.4);
    
    // Draw wing structures
    fill(150, 0, 150);
    // Left wing
    ellipse(x - size * 0.7, y, size * 0.5, size * 0.3);
    // Right wing
    ellipse(x + size * 0.7, y, size * 0.5, size * 0.3);
    
    // Draw health bar
    noStroke();
    fill(100, 100, 100);
    rect(x - size/2, y - size - 10, size, 5);
    fill(255 * (1 - health/300.0), 255 * (health/300.0), 0);
    rect(x - size/2, y - size - 10, size * (health / 300.0), 5);
  }
  
  void shoot() {
    // Boss shoots 3 bullets at once
    bullets.add(new Bullet(x, y + size/2, true));
    bullets.add(new Bullet(x - 20, y + size/2, true));
    bullets.add(new Bullet(x + 20, y + size/2, true));
  }
  
  boolean hits(Player player) {
    float distance = dist(x, y, player.x, player.y);
    return distance < (size/2 + player.size/2);
  }
}