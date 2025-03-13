// Enemy class
class Enemy {
  float x, y;
  float size = 25;
  float speed = 2;
  int health = 30;
  float direction = 1;  // 1 for right, -1 for left
  
  Enemy(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void update() {
    // Move side to side
    x += speed * direction;
    
    // Change direction at edges
    if (x > width - size/2 || x < size/2) {
      direction *= -1;
      y += 10;  // Move down a bit
    }
  }
  
  void display() {
    // Draw enemy ship
    fill(255, 50, 50);
    ellipse(x, y, size, size);
    
    // Draw enemy details
    fill(150, 0, 0);
    ellipse(x, y, size * 0.7, size * 0.7);
    fill(200, 0, 0);
    ellipse(x, y, size * 0.4, size * 0.4);
    
    // Draw health bar
    noStroke();
    fill(100, 100, 100);
    rect(x - size/2, y - size - 5, size, 3);
    fill(255 * (1 - health/30.0), 255 * (health/30.0), 0);
    rect(x - size/2, y - size - 5, size * (health / 30.0), 3);
  }
  
  void shoot() {
    bullets.add(new Bullet(x, y + size/2, true));
  }
  
  boolean hits(Player player) {
    float distance = dist(x, y, player.x, player.y);
    return distance < (size/2 + player.size/2);
  }
}