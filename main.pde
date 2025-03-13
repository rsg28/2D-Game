// Space Shooter Game - Main File
// A simple 2D space shooter with enemies and a final boss

// Game objects
Player player;
ArrayList<Enemy> enemies;
ArrayList<Bullet> bullets;
ArrayList<Particle> particles;
Boss boss;

// Game state
int enemiesDefeated = 0;
int requiredDefeats = 10;
boolean bossActive = false;
boolean gameOver = false;
boolean gameWon = false;

// Background stars
Star[] stars = new Star[150];
Planet[] planets = new Planet[3];

void setup() {
  size(800, 600);
  player = new Player(width/2, height - 100);
  enemies = new ArrayList<Enemy>();
  bullets = new ArrayList<Bullet>();
  particles = new ArrayList<Particle>();
  
  // Create stars for background
  for (int i = 0; i < stars.length; i++) {
    stars[i] = new Star();
  }
  
  // Create planets for background
  for (int i = 0; i < planets.length; i++) {
    planets[i] = new Planet();
  }
  
  // Spawn initial enemies
  spawnEnemies(3);
}

void draw() {
  // Draw space background - deep blue instead of black
  background(0, 5, 20);
  
  // Draw stars
  for (Star star : stars) {
    star.display();
    star.twinkle();
  }
  
  // Draw planets
  for (Planet planet : planets) {
    planet.display();
  }
  
  // Display game stats
  fill(255);
  textSize(16);
  text("Enemies Defeated: " + enemiesDefeated + "/" + requiredDefeats, 20, 30);
  text("Health: " + player.health, 20, 55);
  
  // Game over or win state
  if (gameOver) {
    textSize(32);
    textAlign(CENTER);
    fill(255, 0, 0);
    text("GAME OVER", width/2, height/2);
    textSize(20);
    fill(255);
    text("Press 'R' to restart", width/2, height/2 + 40);
    return;
  } else if (gameWon) {
    textSize(32);
    textAlign(CENTER);
    fill(0, 255, 0);
    text("YOU WIN!", width/2, height/2);
    textSize(20);
    fill(255);
    text("Press 'R' to play again", width/2, height/2 + 40);
    return;
  }
  
  // Update and display particles
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.display();
    if (p.isDead()) {
      particles.remove(i);
    }
  }
  
  // Update and display player
  player.update();
  player.display();
  
  // Update and display bullets
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet bullet = bullets.get(i);
    bullet.update();
    bullet.display();
    
    // Remove bullets that go off screen
    if (bullet.offScreen()) {
      bullets.remove(i);
      continue;
    }
    
    // Check for hits on enemies
    if (!bullet.isEnemyBullet) {
      for (int j = enemies.size() - 1; j >= 0; j--) {
        Enemy enemy = enemies.get(j);
        if (bullet.hits(enemy)) {
          enemy.health -= bullet.damage;
          createExplosion(bullet.x, bullet.y, 5, color(255, 255, 0));
          bullets.remove(i);
          
          if (enemy.health <= 0) {
            createExplosion(enemy.x, enemy.y, 20, color(255, 100, 0));
            enemies.remove(j);
            enemiesDefeated++;
            
            // Check if we should spawn boss
            if (enemiesDefeated >= requiredDefeats && !bossActive) {
              spawnBoss();
            } else if (enemies.size() == 0) {
              // Spawn more enemies if not time for boss yet
              spawnEnemies(3);
            }
          }
          break;
        }
      }
    }
    
    // Check for hits on player
    if (bullet.isEnemyBullet && bullet.hits(player)) {
      player.health -= bullet.damage;
      createExplosion(bullet.x, bullet.y, 5, color(255, 0, 0));
      bullets.remove(i);
      
      if (player.health <= 0) {
        createExplosion(player.x, player.y, 30, color(0, 200, 255));
        gameOver = true;
      }
    }
    
    // Check for hits on boss
    if (bossActive && !bullet.isEnemyBullet && bullet.hits(boss)) {
      boss.health -= bullet.damage;
      createExplosion(bullet.x, bullet.y, 5, color(255, 0, 255));
      bullets.remove(i);
      
      if (boss.health <= 0) {
        createExplosion(boss.x, boss.y, 50, color(255, 0, 255));
        bossActive = false;
        gameWon = true;
      }
    }
  }
  
  // Update and display enemies
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy enemy = enemies.get(i);
    enemy.update();
    enemy.display();
    
    // Enemy shooting
    if (random(1) < 0.01) {
      enemy.shoot();
    }
    
    // Check for collisions with player
    if (enemy.hits(player)) {
      player.health -= 20;
      createExplosion(enemy.x, enemy.y, 15, color(255, 100, 0));
      enemies.remove(i);
      
      if (player.health <= 0) {
        createExplosion(player.x, player.y, 30, color(0, 200, 255));
        gameOver = true;
      }
    }
  }
  
  // Update and display boss if active
  if (bossActive) {
    boss.update();
    boss.display();
    
    // Boss shooting
    if (random(1) < 0.05) {
      boss.shoot();
    }
    
    // Check for collisions with player
    if (boss.hits(player)) {
      player.health -= 30;
      createExplosion(player.x, player.y, 15, color(255, 0, 255));
      
      if (player.health <= 0) {
        createExplosion(player.x, player.y, 30, color(0, 200, 255));
        gameOver = true;
      }
    }
  }
}

void keyPressed() {
  if (key == 'a' || keyCode == LEFT) {
    player.movingLeft = true;
  }
  if (key == 'd' || keyCode == RIGHT) {
    player.movingRight = true;
  }
  if (key == 'w' || keyCode == UP) {
    player.movingUp = true;
  }
  if (key == 's' || keyCode == DOWN) {
    player.movingDown = true;
  }
  if (key == ' ') {
    player.shoot();
  }
  if (key == 'r' && (gameOver || gameWon)) {
    resetGame();
  }
}

void keyReleased() {
  if (key == 'a' || keyCode == LEFT) {
    player.movingLeft = false;
  }
  if (key == 'd' || keyCode == RIGHT) {
    player.movingRight = false;
  }
  if (key == 'w' || keyCode == UP) {
    player.movingUp = false;
  }
  if (key == 's' || keyCode == DOWN) {
    player.movingDown = false;
  }
}

void spawnEnemies(int count) {
  for (int i = 0; i < count; i++) {
    enemies.add(new Enemy(random(50, width - 50), random(50, height/2)));
  }
}

void spawnBoss() {
  boss = new Boss(width/2, 100);
  bossActive = true;
}

void resetGame() {
  player = new Player(width/2, height - 100);
  enemies = new ArrayList<Enemy>();
  bullets = new ArrayList<Bullet>();
  particles = new ArrayList<Particle>();
  bossActive = false;
  enemiesDefeated = 0;
  gameOver = false;
  gameWon = false;
  spawnEnemies(3);
}

void createExplosion(float x, float y, int count, color particleColor) {
  for (int i = 0; i < count; i++) {
    particles.add(new Particle(x, y, particleColor));
  }
}