import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
Minim minim; //Minim型変数であるminimの宣言
AudioPlayer bgmTitle; //サウンドデータ格納用の変更
AudioPlayer bgmGame; //サウンドデータ格納用の変更
AudioPlayer bgmClear;
AudioPlayer bgmGameover;
AudioPlayer startSound;
AudioPlayer swordSound;
AudioPlayer damageSound;
AudioPlayer HealSound;
AudioPlayer FireSound;


int state;    // 現在の状態 (0=タイトル, 1=ゲーム, 2=エンディング)
long t_start; // 現在の状態になった時刻[ミリ秒]
float t;      // 現在の状態になってからの経過時間[秒]
int healingItem;
boolean healingItemActive = false;
float Heal_X, Heal_Y;
int FireItem;
boolean FireItemActive = false;
float Fire_X, Fire_Y;
boolean keyDown = false;

PImage stageImage; // ステージの画像
PImage characterImage; // キャラクターの画像
PImage image2;
PImage image3;
PImage image4;
PImage image5;
PImage image6;
PImage image7; //攻撃L
PImage image8;
PImage image9;
PImage image10;
PImage image11; //攻撃R
PImage image12;
PImage image13;
PImage image14;
PImage image15; //透明画像
PImage image16; //回復ポーション
PImage image17; //火アイコン

// 敵キャラクター
PImage[] doragonImages = new PImage[3];
PImage[] kituneImages = new PImage[3];
PImage[] mahouImages = new PImage[3];
PImage[] obakeImages = new PImage[3];
PImage[] okamiImages = new PImage[2];
PImage[] goburinImages = new PImage[2];

PImage titleimage;

long lastMousePressedTime = 0;
int attackFrameIndex = 0;
PImage[] leftAttackImages;
PImage[] rightAttackImages;

int stageWidth = 1600; // ステージの幅
int stageHeight = 1200; // ステージの高さ
int screenWidth = 800; // 画面の幅
int screenHeight = 600; // 画面の高さ
int charSize = 100; // キャラクターのサイズ
int charX = stageWidth / 2; // キャラクターの初期X座標
int charY = stageHeight / 2; // キャラクターの初期Y座標
int charSpeed = 5; // キャラクターの移動速度
int offsetX, offsetY; // 背景のオフセット
int enemyCount = 0; //敵の数
int timeLimit =3;//時間経過
int countDown;//秒数経ったらクリア画面に遷移
int ms ;

boolean moveLeft = false;
boolean moveRight = false;
boolean moveUp = false;
boolean moveDown = false;

int playerHP = 100; // プレイヤーのHP
int maxHP = 100; // プレイヤーの最大HP

ArrayList<Enemy> enemies = new ArrayList<Enemy>(); // 敵キャラクターのリスト

long gameStartTime = 0; // ゲーム開始時刻
long gameEndTime = 0;   // ゲーム終了時刻
boolean gameEnded = false; // ゲームが終了したかどうか
int maxEnemies = 15; // 最大敵キャラクター数
int defeatedEnemies = 0; // 倒された敵キャラクター数
import java.io.*;

String fileName = "score.csv"; // CSVファイル名

void setup(){
  size(800, 600);
  smooth();
  
  // 画像の読み込み
  stageImage = loadImage("stage.jpg");
  characterImage = loadImage("front.png");
  image2 = loadImage("back.png");
  image3 = loadImage("left_1.png");
  image4 = loadImage("left_2.png");
  image5 = loadImage("Right1.png");
  image6 = loadImage("Right2.png");
  image7 =loadImage("front.png");
  image8 =loadImage("Attack_L2.png");
  image9 =loadImage("Attack_L3.png");
  image10 =loadImage("Attack_L4.png");
  image11 =loadImage("front.png");
  image12 =loadImage("Attack_R2.png");
  image13 =loadImage("Attack_R3.png");
  image14 =loadImage("Attack_R4.png");
  image15 = loadImage("Skelton.png");
  image16 = loadImage("Heal.png");
  image17 = loadImage("Fire.png");
  titleimage = loadImage("title.png");

  // 敵キャラクター画像の読み込み
  doragonImages[0] = loadImage("doragon1.png");
  doragonImages[1] = loadImage("doragon2.png");
  doragonImages[2] = loadImage("doragon3.png");
  
  kituneImages[0] = loadImage("kitune1.png");
  kituneImages[1] = loadImage("kitune2.png");
  kituneImages[2] = loadImage("kitune3.png");
  
  mahouImages[0] = loadImage("mahou1.png");
  mahouImages[1] = loadImage("mahou2.png");
  mahouImages[2] = loadImage("mahou3.png");
  
  obakeImages[0] = loadImage("obake1.png");
  obakeImages[1] = loadImage("obake2.png");
  obakeImages[2] = loadImage("obake3.png");
  
  okamiImages[0] = loadImage("okami1.png");
  okamiImages[1] = loadImage("okami2.png");
  
  goburinImages[0] = loadImage("goburin1.png");
  goburinImages[1] = loadImage("goburin2.png");

  leftAttackImages = new PImage[] { image7, image8, image9, image10, image15};
  rightAttackImages = new PImage[] { image11, image12, image13, image14,image15};
  
  healingItem = int(random(5,20)); //5から20ランダム数でその数敵を倒したら回復アイテム表示
  FireItem = int(random(5,20)); //5から20ランダム数でその数敵を倒したら必殺アイテム表示

  textSize(32);
  textAlign(CENTER);
  fill(255);
  state = 0;
  
  //日本語を使えるようにする
  PFont font = createFont("Meiryo", 50);
  textFont(font);
  
  minim = new Minim(this); //初期化,thisは現在のオブジェクトを参照する。
  bgmTitle = minim.loadFile("title.mp3");
  bgmGame = minim.loadFile("game.mp3");
  bgmClear = minim.loadFile("clear.mp3");
  bgmGameover = minim.loadFile("lose.mp3");
  swordSound = minim.loadFile("sword.mp3");
  damageSound = minim.loadFile("damage.mp3");
  startSound = minim.loadFile("sword.mp3");
  FireSound = minim.loadFile("Fire.mp3");
  HealSound = minim.loadFile("Heal.mp3");
  bgmTitle.loop();
  // ハイスコアの読み込み
  float highScore = readHighScore();
  println("High Score: " + highScore + " seconds");
}

void draw(){
  background(0);
 
  int nextState = 0;
  if (state == 0) { 
    nextState = title(); 
  } else if (state == 1) { 
    nextState = game(); 
  }
  else if (state == 2) { 
    nextState = ending(); 
  }
 
  state = nextState;
}

int title(){
  fill(255,255,255);
  text("Warrior", width * 0.5, height * 0.3 - 50);
  
  text("[a]を押して開始", width * 0.5, height * 0.7 + 50);
  scale(0.2);
  image(titleimage, width * 0.5 + titleimage.width / 2, height * 0.5 + titleimage.height - 700);
  scale(2);
  fill(255,255,51);
  text("右クリック>>攻撃R", width * 0.4, height * 0.1 + 50);
  text("左クリック>>攻撃L", width * 0.4, height * 0.1 + 100);
  fill(255,255,255);
  text("*火のアイコン表示時",width * 0.4, height * 0.1 + 200);
  fill(255,255,51);
  text("Enterキー>>必殺技 ", width * 0.4, height * 0.1 + 250);
  fill(255,255,255);
  text("*回復アイコン表示時", width * 0.4, height * 0.1 + 350);
  fill(255,255,51);
  text("Spaceキー>>回復 ", width * 0.4, height * 0.1 + 400);

  if (keyPressed && key == 'a') { // if 'a' key is pressed
   gameStartTime = millis(); // ゲーム開始時刻を記録
    gameEnded = false; // ゲーム終了フラグをリセット
     enemies.clear(); // 敵キャラクターのリストをクリア
    enemyCount = 0; // 敵の数をリセット
      defeatedEnemies = 0; // 倒された敵の数をリセット
      playerHP = 100;
      startSound.play();
      bgmTitle.close();
      bgmGame.loop();
    
    return 1; // start game
  }
  return 0;
}


int game(){
  background(255); // 毎フレーム背景をクリア
  
  // オフセットの計算
  offsetX = charX - screenWidth / 2;
  offsetY = charY - screenHeight / 2;
  
  // オフセットがステージの端を超えないように制御
  offsetX = constrain(offsetX, 0, stageWidth - screenWidth);
  offsetY = constrain(offsetY, 0, stageHeight - screenHeight);
  
  // ステージの画像を描画
  image(stageImage, -offsetX, -offsetY, stageWidth, stageHeight);
  
  // キャラクターの画像を描画
  float drawCharX = charX - offsetX;
  float drawCharY = charY - offsetY;
  if (keyDown == false && mousePressed == false){
      image(characterImage, drawCharX - charSize / 2, drawCharY - charSize / 2, charSize, charSize);
  }
  
  // キャラクターの移動
  if (moveLeft && !mousePressed) {
    charX = max(charX - charSpeed, charSize / 2 + 180);
    if (moveUp) {
      charY = max(charY - charSpeed, charSize / 2 + 100);
    }
    if (moveDown) {
      charY = min(charY + charSpeed, stageHeight - charSize / 2 - 150);
    }
    if (charX % 3 == 0) {
      image(image3, drawCharX - charSize / 2, drawCharY - charSize / 2, charSize, charSize);
    } else {
      image(image4, drawCharX - charSize / 2, drawCharY - charSize / 2, charSize, charSize);
    }
  } else if (moveRight && !mousePressed) {
    charX = min(charX + charSpeed, stageWidth - charSize / 2 - 180);
    if (moveUp) {
      charY = max(charY - charSpeed, charSize / 2 + 100);
    }
    if (moveDown) {
      charY = min(charY + charSpeed, stageHeight - charSize / 2 - 150);
    }
    if (charX % 3 == 0) {
      image(image6, drawCharX - charSize / 2, drawCharY - charSize / 2, charSize, charSize);
    } else {
      image(image5, drawCharX - charSize / 2, drawCharY - charSize / 2, charSize, charSize);
    }
  } else if (moveUp && !mousePressed) {
    charY = max(charY - charSpeed, charSize / 2 + 100);
    image(image2, drawCharX - charSize / 2, drawCharY - charSize / 2, charSize, charSize);
  } else if (moveDown && !mousePressed) {
    charY = min(charY + charSpeed, stageHeight - charSize / 2 - 150);
    image(characterImage, drawCharX - charSize / 2, drawCharY - charSize / 2, charSize, charSize);
  } else {
    keyDown = false;
  }
  
  // 敵キャラクターの生成と描画
  if (frameCount % 75 == 0 ) { // 60フレームごとに敵を生成
    float enemyX = random(stageWidth);
    float enemyY = random(stageHeight);
    PImage[] enemyImages = randomEnemyImages();  // ここで使用する敵の画像セットを選択
    int enemyHP = determineEnemyHP(enemyImages); // 敵のHPを決定
    int enemyAttack =determineEnemyAttack(enemyImages); 
    enemies.add(new Enemy(enemyX, enemyY, enemyImages,enemyHP,enemyAttack));
    enemyCount++;
  }
  
  //回復アイテムの表示と体力回復
  if (healingItemActive) {
    image(image16, Heal_X, Heal_Y);
    
    // プレイヤーが回復アイテムに触れた場合
    if (keyPressed && key == ' ' && healingItemActive) {
      playerHP = playerHP + 30;
      if (playerHP > 100){
          playerHP = 100;
      }
      HealSound.rewind();
      HealSound.play();
      healingItemActive = false;
      healingItem = 1000; ///以降回復アイテムなし
    }
  } else if (!healingItemActive && defeatedEnemies >= healingItem) {
    // 回復アイコン生成
    Heal_X = 740;
    Heal_Y = 530;
    healingItemActive = true;
  }
  
  println(healingItem, FireItem, defeatedEnemies);//ここで何体倒したら各々のアイテムが表示されるかの確認
  //必殺アイテムの表示と発動
  if (FireItemActive) {
    image(image17, Fire_X, Fire_Y);
    for (Enemy enemy : enemies){
      // プレイヤーが回復アイテムに触れた場合
      if (keyPressed && key == ENTER) {
        if (dist(drawCharX, drawCharY, enemy.x - offsetX, enemy.y - offsetY) < (charSize*10)){
          enemy.takeDamage(20);
        }
        FireSound.rewind();
        FireSound.play();
        FireItemActive = false;
        FireItem = 1000; ///以降必殺アイテムなし
      }
    }
    
  } else if (!FireItemActive && defeatedEnemies >= FireItem) {
    //必殺アイコン生成
    Fire_X = 733;
    Fire_Y = 475;
    FireItemActive = true;
  }
  
  // 敵キャラクターの描画と移動
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy enemy = enemies.get(i);
    enemy.moveTowards(charX, charY); // プレイヤーに向かって移動
    enemy.update();//近くなったらHPを減少
    enemy.display(offsetX, offsetY); // 描画
    if (enemy.isDead()) {
      enemies.remove(i);
      defeatedEnemies++;
      enemyCount--;
    }
  }
  // 敵が全て倒された場合の処理
  if (defeatedEnemies >= maxEnemies && !gameEnded) {
    gameEndTime = millis(); // ゲーム終了時刻を記録
    float timeTaken = (gameEndTime - gameStartTime) / 1000.0;
    saveTime(timeTaken); // 時間をCSVファイルに保存
   
   
    gameEnded = true;
  }
  // ゲームオーバーのチェック
  if (playerHP <= 0 && !gameEnded) {
    gameEndTime = millis(); // ゲーム終了時刻を記録
    gameEnded = true;
  }
   float Time = (gameEnded ? gameEndTime : millis()) - gameStartTime;
  textSize(24);
  fill(0, 0, 0);
  text("経過時間: " + Time / 1000.0 + "秒", width - 150, 70);
  
   //残りの敵の数の表示
  textSize(24);
  fill(0, 0, 255);
  text("敵の数：" + enemyCount, width-100, 30);
  println(defeatedEnemies);
  println(maxEnemies);
  
  
  
  // HPゲージの描画
  drawHPGauge();
  
  
  // 攻撃処理
  if (mousePressed) {
    long elapsedTime = millis() - lastMousePressedTime;
    int frameDuration = 100; 
    attackFrameIndex = (int)(elapsedTime / frameDuration) % 4;
    
    PImage[] attackImages = (mouseButton == LEFT) ? leftAttackImages : rightAttackImages;
    image(attackImages[attackFrameIndex], drawCharX - charSize / 2, drawCharY - charSize / 2, charSize, charSize);
    
    if (attackFrameIndex == 2) {
      // クリック時に効果音を再生
      swordSound.rewind();
      swordSound.play();
      for (Enemy enemy : enemies) {
        // 左クリックの場合、プレイヤーの左側にいる敵にダメージを与える
        if (mouseButton == LEFT && enemy.x < charX) {
          if (dist(drawCharX, drawCharY, enemy.x - offsetX, enemy.y - offsetY) < charSize && frameCount %4==0) {
            enemy.takeDamage(10);//画像が一周したらダメージを与える
            
          }
        }
        // 右クリックの場合、プレイヤーの右側にいる敵にダメージを与える
        if (mouseButton == RIGHT && enemy.x > charX) {
          if (dist(drawCharX, drawCharY, enemy.x - offsetX, enemy.y - offsetY) < charSize && frameCount %4==0) {
            enemy.takeDamage(10);
            //画像が一周したらダメージを与える
            
          }
        }
      }
    }
  }
  //ゲーム終了後の処理*(後で変える)
  if (playerHP <= 0) {
    bgmGame.close();
    playerHP =0;
    textSize(50);
    fill(255, 0, 0);
    text("Game Over", width / 2, height / 2);
    fill(255,255,255);
    text("[b]を押してタイトル画面へ", width / 2, height / 2+100);
    
    bgmGameover.play();
   
  
  if (keyPressed && key == 'b') {
    setup();
    println(defeatedEnemies);
     println(maxEnemies);
    return 0;
  }}
  else if ( defeatedEnemies >= maxEnemies) {
    ms =millis()/1000;
    countDown = timeLimit - ms;
    textSize(50);
    fill(0, 255, 0);
    text("You Win!", width / 2, height / 2);
    
    
    return 2;
  }
  return 1;
}
//ランダムで敵を生成
PImage[] randomEnemyImages() {
  int enemyType = int(random(6));
  switch (enemyType) {
    case 0:
      return doragonImages;
    case 1:
      return kituneImages;
    case 2:
      return mahouImages;
    case 3:
      return obakeImages;
    case 4:
      return okamiImages;
    case 5:
      return goburinImages;
    default:
      return doragonImages; // デフォルトでドラゴン画像を返す
  }
}
int ending(){
  bgmGame.close();
  bgmClear.play();
  long clearTimeMillis = gameEndTime - gameStartTime;
  float clearTimeSeconds = clearTimeMillis / 1000.0;
  
  background(0);
  fill(0,255,127);
  text("Game Clear!", width * 0.5, height * 0.3);
   fill(255,255,51);
  text("倒した敵の数: " + defeatedEnemies, width * 0.5, height * 0.4);
 
  text("クリア時間: " + clearTimeSeconds + " seconds", width * 0.5, height * 0.5);
  
  float highScore = readHighScore();
  fill(255,153,51);
  text("High Score: " + highScore + " seconds", width * 0.5, height * 0.6);
 fill(255,255,51);
  text("[c]を押してタイトル画面へ", width * 0.5, height * 0.8);
  
  if (keyPressed && key == 'c') {
    FireItemActive = false;
    healingItemActive = false;
    setup();
    return 0; // タイトル画面に戻る
  }
  
  return 2; // エンディング画面を維持
}


// キーが押されたときの処理
void keyPressed() {
  if (keyCode == LEFT) {
    moveLeft = true;
    keyDown = true;
  } else if (keyCode == RIGHT) {
    moveRight = true;
    keyDown = true;
  } else if (keyCode == UP) {
    moveUp = true;
    keyDown = true;
  } else if (keyCode == DOWN) {
    moveDown = true;
    keyDown = true;
  }
}

// キーが離されたときの処理
void keyReleased() {
  if (keyCode == LEFT) {
    moveLeft = false;
  } else if (keyCode == RIGHT) {
    moveRight = false;
  } else if (keyCode == UP) {
    moveUp = false;
  } else if (keyCode == DOWN) {
    moveDown = false;
  }
}

// マウスが押されたときの処理
void mousePressed() {
  lastMousePressedTime = millis();
  if (mouseButton == LEFT) {
    println("Left mouse button pressed");
  } else if (mouseButton == RIGHT) {
    println("Right mouse button pressed");
  }
}
//HPを描画
void drawHPGauge() {
  if (playerHP <0) {
    playerHP =0;
  }
  int gaugeWidth = 200; // ゲージの幅
  int gaugeHeight = 20; // ゲージの高さ
  int gaugeX = 10; // ゲージのX座標
  int gaugeY = 10; // ゲージのY座標
  
  // 背景の描画
  fill(100);
  rect(gaugeX, gaugeY, gaugeWidth, gaugeHeight);
  
  // 現在のHPの割合を計算
  float hpRatio = (float)playerHP / maxHP;
  if (playerHP ==0) {
    playerHP =0;
  }
  
  // HPの部分を描画
  fill(0, 0, 255);
  rect(gaugeX, gaugeY, gaugeWidth * hpRatio, gaugeHeight);
  fill(0);
  textSize(25);
  text("HP", 230, 30);
}

// 敵キャラクターのクラス
class Enemy {
  float x, y; // 敵キャラクターの位置
  float speed ; // 敵キャラクターの移動速度
  int hp; // 敵キャラクターのHP
  PImage[] images; // 敵キャラクターの画像
  int currentImageIndex = 0; // 現在表示する画像のインデックス
  float size;
  int damageTaken = 0; // 受けたダメージ
   long damageDisplayStartTime; // ダメージ表示開始時刻
    boolean showDamage = false; // ダメージ表示フラグ
    int Attack;

  Enemy(float x, float y, PImage[] images,int hp,int Attack) {
    this.x = x;
    this.y = y;
    this.images = images;
    this.hp = hp;
    this.Attack = Attack;
    size =50;
    
    speed = random(1, 2);
  }

  // 敵キャラクターを描画する
  void display(float offsetX, float offsetY) {
    image(images[currentImageIndex], x - offsetX - charSize / 2, y - offsetY - charSize / 2, 85, 85);
    textSize(24);
    fill(0, 0, 0);
    text(hp, x - offsetX - charSize / 8, y - offsetY - charSize / 2);
  
    if (frameCount % 10 == 0) {
      currentImageIndex = (currentImageIndex + 1) % images.length; // 画像をアニメーションさせる
    }
    if (showDamage) {
      fill(255, 0, 0);
      textSize(20);
      text(damageTaken, x - offsetX, y - offsetY - 40);
      if (millis() - damageDisplayStartTime > 500) { // 0.5秒後に表示を消す
        showDamage = false;
      }
    }
  }
  void update() {
    float angle = atan2(charY - y, charX - x);
    x += cos(angle) * speed;
    y += sin(angle) * speed;
    float distanceToPlayer = dist(charX, charY, x, y);
    if (distanceToPlayer < charSize / 2 + size / 2 &&frameCount % 30 == 0 ) {
      playerHP =playerHP- Attack; // HPを減少させる //*追加//近づいて、ある程度のフレームがカウントされたら
      if (playerHP > 0){
        damageSound.rewind();
        damageSound.play();
      }
    }
  }

  // 敵キャラクターをプレイヤーに向かって移動させる
  void moveTowards(float targetX, float targetY) {
    float angle = atan2(targetY - y, targetX - x);
    //敵がプレイヤーまで近づく
    if (dist(charX, charY, x, y) >charSize / 2 + size / 2) {
    x += cos(angle) * speed;
    y += sin(angle) * speed;}
    //近づいたら止まる
    else if (dist(charX, charY, x, y) <charSize / 3+ size / 2) {
      x -= cos(angle) * speed;
    y -= sin(angle) * speed;
  }}
  

  // 敵キャラクターにダメージを与える
  void takeDamage(int damage) {
    hp -= damage;
     damageTaken = damage; // 受けたダメージを記録
    showDamage = true; // ダメージ表示フラグを立てる
    damageDisplayStartTime = millis(); // ダメージ表示開始時刻を記録
  }

  // 敵キャラクターが死んだかどうかを確認する
  boolean isDead() {
    return hp <= 0;
  }
  
}
//敵のよってHPを変える
int determineEnemyHP(PImage[] enemyImages) {
  if (enemyImages == doragonImages) {
    return 50;
  } else if (enemyImages == kituneImages) {
    return 30;
  } else if (enemyImages == mahouImages) {
    return 40;
  } else if (enemyImages == obakeImages) {
    return 40;
  } else if (enemyImages == okamiImages) {
    return 30;
  } else if (enemyImages == goburinImages) {
    return 20;
  } else {
    return 30; // デフォルトのHP
  }
}
//敵によって攻撃力を変える
int determineEnemyAttack(PImage[] enemyImages) {
    if (enemyImages == doragonImages) {
    return 3;
  } else if (enemyImages == kituneImages) {
    return 2;
  } else if (enemyImages == mahouImages) {
    return 2;
  } else if (enemyImages == obakeImages) {
    return 2;
  } else if (enemyImages == okamiImages) {
    return 2;
  } else if (enemyImages == goburinImages) {
    return 1;
  } else {
    return 1; // デフォルトのHP
  }
    
    
  }

void stop() {
  // プログラム終了時にオーディオリソースを解放
  bgmTitle.close();
  bgmGame.close();
  bgmClear.close();
  bgmGameover.close();
  startSound.close();
  swordSound.close();
  damageSound.close();
  HealSound.close();
  FireSound.close();
  minim.stop();
  super.stop();
}
// 敵を倒すまでにかかった時間をCSVファイルに記録するメソッド
void saveTime(float time) {
  try {
    PrintWriter writer = new PrintWriter(new FileWriter(fileName, true));
    writer.println(time);
    writer.close();
  } catch (IOException e) {
    println("An error occurred while saving the time.");
    e.printStackTrace();
  }
}

// ハイスコアを読み込むメソッド
float readHighScore() {
  float highScore = Float.MAX_VALUE;
  
  try {
    BufferedReader reader = new BufferedReader(new FileReader(fileName));
    String line;
    
    while ((line = reader.readLine()) != null) {
      float time = Float.parseFloat(line);
      if (time < highScore) {
        highScore = time;
      }
    }
    
    reader.close();
  } catch (IOException e) {
    println("An error occurred while reading the high score.");
    e.printStackTrace();
  } catch (NumberFormatException e) {
    println("Invalid number format in CSV file.");
    e.printStackTrace();
  }
  
  return (highScore == Float.MAX_VALUE) ? 0 : highScore;
}
