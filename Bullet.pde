// Bullet class
class Bullet {
  float x, y;
  float size = 5;
  float speed = 7;
  boolean isEnemyBullet;
  int damage;
  color bulletColor;
  float angle = 0;
  
  Bullet(float x, float y, boolean isEnemyBullet) {
    this.x = x;
    this.y = y;
    this.isEnemyBullet = isEnemyBullet;
    this.damage = isEnemyBullet ? 10 : 15;
    
    // Different colored bullets for player and enemies
    if (isEnemyBullet) {
      this.bulletColor = color(255, 100, 0);
    } else {
      this.bulletColor = color(0, 255, 255);
    }
  }
  
  void update() {
    if (isEnemyBullet) {
      y += speed;
    } else {
      y -= speed;
    }
    
    // Rotate bullet for visual effect
    angle += 0.2;
    
    // Occasionally create trail particles
    if (frameCount % 3 == 0) {
      particles.add(new Particle(x, y, bulletColor));
    }
  }
  
  void display() {
    pushMatrix();
    translate(x, y);
    rotate(angle);
    
    // Bullet glow
    noStroke();
    fill(red(bulletColor), green(bulletColor), blue(bulletColor), 100);
    ellipse(0, 0, size * 2, size * 2);
    
    // Bullet core
    fill(bulletColor);
    if (isEnemyBullet) {
      // Enemy bullets are diamond-shaped
      quad(0, -size, size, 0, 0, size, -size, 0);
    } else {
      // Player bullets are star-shaped
      beginShape();
      for (int i = 0; i < 5; i++) {
        float angle = TWO_PI * i / 5;
        float x1 = cos(angle) * size;
        float y1 = sin(angle) * size;
        vertex(x1, y1);
        
        float angle2 = TWO_PI * (i + 0.5) / 5;
        float x2 = cos(angle2) * (size/2);
        float y2 = sin(angle2) * (size/2);
        vertex(x2, y2);
      }
      endShape(CLOSE);
    }
    popMatrix();
  }
  
  boolean offScreen() {
    return y < 0 || y > height;
  }
  
  boolean hits(Enemy enemy) {
    float distance = dist(x, y, enemy.x, enemy.y);
    return distance < (size + enemy.size/2);
  }
  
  boolean hits(Player player) {
    float distance = dist(x, y, player.x, player.y);
    return distance < (size + player.size/2);
  }
  
  boolean hits(Boss boss) {
    float distance = dist(x, y, boss.x, boss.y);
    return distance < (size + boss.size/2);
  }
}