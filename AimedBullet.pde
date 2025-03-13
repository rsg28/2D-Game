// AimedBullet class that extends Bullet
class AimedBullet extends Bullet {
  float vx, vy;
  
  AimedBullet(float x, float y, boolean isEnemyBullet, float targetX, float targetY) {
    super(x, y, isEnemyBullet);
    
    // Calculate direction vector toward target
    float dx = targetX - x;
    float dy = targetY - y;
    
    // Normalize the direction vector
    float length = sqrt(dx*dx + dy*dy);
    dx /= length;
    dy /= length;
    
    // Set velocity components based on bullet speed
    vx = dx * speed;
    vy = dy * speed;
  }
  
  @Override
  void update() {
    // Move along the calculated trajectory
    x += vx;
    y += vy;
    
    // Rotate bullet for visual effect
    angle += 0.2;
    
    // Occasionally create trail particles
    if (frameCount % 3 == 0) {
      particles.add(new Particle(x, y, bulletColor));
    }
  }
  
  @Override
  boolean offScreen() {
    return x < 0 || x > width || y < 0 || y > height;
  }
}