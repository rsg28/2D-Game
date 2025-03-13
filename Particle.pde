// Particle class for explosions and effects
class Particle {
  float x, y;
  float vx, vy;
  float size;
  color particleColor;
  float alpha;
  float decay;
  
  Particle(float x, float y, color particleColor) {
    this.x = x;
    this.y = y;
    this.vx = random(-2, 2);
    this.vy = random(-2, 2);
    this.size = random(1, 4);
    this.particleColor = particleColor;
    this.alpha = 255;
    this.decay = random(5, 10);
  }
  
  void update() {
    x += vx;
    y += vy;
    alpha -= decay;
  }
  
  void display() {
    noStroke();
    fill(red(particleColor), green(particleColor), blue(particleColor), alpha);
    ellipse(x, y, size, size);
  }
  
  boolean isDead() {
    return alpha <= 0;
  }
}