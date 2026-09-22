import processing.sound.*;// 匯入 Processing 的音效套件（播放 mp3 / wav）
SoundFile mySound;    // 背景音樂
SoundFile shootSound; // 射擊音效

PImage Plane;
PImage Enemy;
PImage backgroundImg;

float step=5;// 飛機移動速度（每次移動幾個像素）
Plane plane;  // 飛機物件
boolean [] keys = new boolean[256];// 記錄鍵盤按鍵狀態（WSAD 是否按住）
Enemy [] enemys = new Enemy[5];// 敵人陣列（同時出現 5 隻）
int yourlife=10;  // 玩家生命值
int score=0; // 目前分數


int bestScore=0;
boolean gameOver=false;
boolean gameBegin=false;

ArrayList<Ammo> ammos=new ArrayList<Ammo>(); // 子彈清單（動態增減子彈）

int firespeed=10; // 子彈發射間隔（越小越密集）
int count=0; // 計時器（用來控制發射頻率）

void setup()
{
  size(600,800);
  backgroundImg = loadImage("background.png");
  mySound = new SoundFile(this, "bgm.mp3");
  shootSound = new SoundFile(this, "shoot.wav");

  mySound.loop();    // 背景音樂一直播放
  mySound.amp(0.3);  // 音量小一點比較舒服
  
  Plane=loadImage("Plane.png");
  Enemy=loadImage("Enemy.png");
  
  Plane.resize(150,150);
  Enemy.resize(70,70);
  plane=new Plane(width/2,height-150); // 建立飛機物件（起始位置在下方中央）
  
  for(int i=0;i<enemys.length;i++){ // 初始化每一隻敵人
    enemys[i]=new Enemy(random(10,width-10),random(-100,-50));
  }
  
}
void draw()
{
  if(gameBegin == false) // 如果還沒開始，就顯示開始畫面
  {
    showBegin();
  }
  if(keyPressed && key == 'r' && gameBegin == false) // 按 R 開始遊戲
  {
    gameBegin=true;
  }
  if(keyPressed && key == 'r' && gameOver) // 遊戲結束後按 R 重新開始
  {
    restart();
  }
  if(yourlife<=0) // 生命值歸零   顯示 Game Over
  {
    showOver();
  }
  if(gameOver || gameBegin==false) // 若遊戲結束或尚未開始，不再執行遊戲內容
  {
    return;
  }
  

  imageMode(CORNER); // 保證背景用左上角對齊方式繪製
  noTint(); // 清掉 tint 狀態，避免圖片被染色或透明
  image(backgroundImg, 0, 0, width, height);// 每一幀重新畫背景（避免殘影）


  
drawHUD_SciFi();   // 顯示科幻 HUD（分數 + 生命條）

  
  
  //飛機
  move();// 根據鍵盤狀態移動飛機
  plane.display();// 畫出飛機
  plane.check();// 飛機不能超出邊界
  
  //敵人
  for(int i=0;i<enemys.length;i++){ // 處理所有敵人
    enemys[i].display(); // 更新敵人位置（往下掉、加速）
    enemys[i].update(); // 判斷敵人是否被子彈打到
    enemys[i].hit();
    if(enemys[i].reach()){  // 如果敵人飛出畫面底部  玩家扣血
      yourlife-=1;
      enemys[i]=new Enemy((int)random(10,width-10),-50); // 生成新的敵人補上
    }
    if(enemys[i].die()){ // 如果敵人生命歸零 得分 + 重生
      score++;
      enemys[i]=new Enemy((int)random(10,width-10),-50);
    }
  }
  
  //子彈
  if(count%firespeed==0){ // 每隔 firespeed 幀發射一次子彈
    Ammo ammo1=new Ammo(plane.x-15,plane.y-24);
    Ammo ammo2=new Ammo(plane.x-15,plane.y-24);
    ammos.add(ammo1);  // 加入子彈到清單
    ammos.add(ammo2);
    shootSound.play();   // 射擊音效
  }
  count +=1;
  
  for(int i=0;i<ammos.size();i++) // 更新並顯示每一顆子彈
  {
    Ammo a=(Ammo)ammos.get(i);
    
    a.display(); // 畫出子彈並讓它往上移動
    if(a.check()){ // 如果飛出畫面上方就移除
      ammos.remove(i);
    }
  }
  
}

class Plane//飛機類
{
  float x,y;//x位置,y位置
  Plane(float x,float y)//構造函數
  {
    this.x=x;
    this.y=y;
  }
  void display(){
    tint(255,255);
    imageMode(CENTER);
    image(Plane,x,y);
  }
  void check()
  {
    if(x<0)x=0;if(x>width)x=width;if(y<0) y=0;if(y>height)y=height;
  }
}
void move(){  // 根據按鍵狀態控制飛機移動（按住連續移動）
  if(keys['a'])
    plane.x-=step;
  if(keys['d'])
    plane.x+=step;
  if(keys['w'])
    plane.y-=step;
  if(keys['s'])
    plane.y+=step;
}
void keyPressed(){
  if(key<256) keys[key]=true;
}
void keyReleased(){
  if(key<256) keys[key]=false;
}

//
class Enemy{
  float x,y; // 敵人座標
  float velocity=4;
  float accelerate=0.01;
  int life;
  Enemy(float x,float y)
  {
    this.x=x;
    this.y=y;
    life=(int)random(1,6);
  }
  void display()
  {
    imageMode(CENTER);
    noTint(); 
    image(Enemy,x,y);
  }
  void update()
  {
    y+=velocity;
    velocity += accelerate;
  }
  //
  boolean die(){// 判斷敵人是否死亡（血量 <= 0）
    if(life<=0)//如果飛機生命值小於等於0
    {
      return true;
    } return false;
  }
  //判斷有沒有突破防線
  boolean reach(){  // 判斷敵人是否飛出畫面底部（突破防線）
    if(y>height+25)
    {
      return true;
    } return false;
  }
  void hit(){ // 判斷敵人是否被子彈擊中
    for(int i=0;i<ammos.size();i++){//
      Ammo ammo=(Ammo) ammos.get(i);
      if(dist(x,y,ammo.x,ammo.y)<25){// // 子彈與敵人距離小於 25 命中
        life -=1;
        ammos.remove(i);
      }
    }
  }
}

//子彈

class Ammo
{
  float x,y,speed=9;
  Ammo(float x,float y)
  {
    this.x=x;
    this.y=y;
  }
void display(){
  pushStyle();
  rectMode(CENTER);
  noStroke();

  // 外光暈
  fill(70, 200, 255, 80);
  rect(x, y, 10, 28, 8);

  // 中間光束
  fill(70, 200, 255, 170);
  rect(x, y, 5, 26, 8);

  // 核心亮線
  fill(255, 240);
  rect(x, y, 2, 24, 8);

  y -= speed;   // 子彈往上飛

  popStyle();
}

  boolean check(){
    if(y<0)
    {
      return true;
    }else
      return false;
  }
}

void showOver() // 顯示遊戲結束畫面
{
  gameOver=true;
  for(int i=0;i<ammos.size();i++)
  { // 清空子彈（避免重開還留著）
    ammos.remove(i);
  }
  bestScore=bestScore>score ? bestScore: score ;// 更新最高分
  background(0);
  textAlign(CENTER);
  fill(255);
  textSize(42);
  text("BestScore:"+bestScore,width/2,height/2-100);
  text("Score:"+score,width/2,height/2);
  textSize(20);
  text("Press R to restart",width/2,height/2+100);
}
void restart(){ // 重置遊戲狀態（重新開始）
  gameOver=false;
  score=0;
  yourlife=10;
  plane=new Plane(width/2,height-150);// 飛機回到初始位置
  for(int i=0;i<enemys.length;i++){ // 重新生成敵人
    enemys[i]=new Enemy(random(10,width-10),random(-100,-50));
  }
}
void showBegin()
{ // 顯示開始畫面
  background(0);
  textAlign(CENTER);
  fill(255);
  textSize(30);
  text("Wellcome to our game",width/2,height/2);
  textSize(20);
  text("Press R to start",width/2,height/2+100);
}

void drawHUD_SciFi(){ //HUD：顯示分數與生命值
  pushStyle();
  rectMode(CORNER);
  textAlign(LEFT, TOP);

  // 位置與尺寸
  float x = 16, y = 14;
  float w = 260, h = 92;

  //背板（科幻藍：暗底 + 外框光）
  noStroke();
  fill(0, 140);                 // 暗底
  rect(x, y, w, h, 14);

  stroke(70, 200, 255, 200);    // 霓虹藍外框
  strokeWeight(2);
  noFill();
  rect(x, y, w, h, 14);

  // 角落小裝飾（科技感）
  stroke(70, 200, 255, 160);
  strokeWeight(3);
  line(x+12, y+12, x+42, y+12);
  line(x+12, y+12, x+12, y+32);
  line(x+w-12, y+12, x+w-42, y+12);
  line(x+w-12, y+12, x+w-12, y+32);

  //  文字（白字 + 藍色陰影）
  textSize(18);
  fill(70, 200, 255, 180);  // 藍色陰影
  text("SCORE", x+16+1, y+14+1);
  text("LIFE",  x+16+1, y+46+1);

  fill(255);
  text("SCORE", x+16, y+14);
  text("LIFE",  x+16, y+46);

  // 分數大字
  textSize(26);
  fill(0, 200);  text(score, x+90+2, y+8+2);
  fill(255);     text(score, x+90,   y+8);

  //  LIFE：能量條
  int maxLife = 10;                 // 最大血量
  float barX = x + 90;
  float barY = y + 50;
  float barW = 150;
  float barH = 14;

  // 背景條
  noStroke();
  fill(255, 40);
  rect(barX, barY, barW, barH, 6);

  // 目前血量（藍色霓虹）
  float ratio = constrain((float)yourlife / maxLife, 0, 1);
  fill(70, 200, 255, 220);
  rect(barX, barY, barW * ratio, barH, 6);

  // 外框
  stroke(70, 200, 255, 180);
  strokeWeight(2);
  noFill();
  rect(barX, barY, barW, barH, 6);

  //  LIFE：小格（更有「電池格」感）
  float cellX = barX;
  float cellY = barY + 22;
  float cellW = 10, cellH = 10, gap = 5;

  noStroke();
  for(int i=0; i<maxLife; i++){
    if(i < yourlife) fill(70, 200, 255, 220);  // 有血：亮藍
    else             fill(255, 50);            // 沒血：暗灰
    rect(cellX + i*(cellW+gap), cellY, cellW, cellH, 3);
  }

  popStyle();
}
