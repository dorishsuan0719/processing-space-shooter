# processing-space-shooter
A 2D space shooter survival game developed with Processing.
# Space Shooter Game

A 2D space shooter survival game developed with Processing.

本作品是一款使用 Processing 製作的飛機射擊生存遊戲。
玩家可以使用 W、A、S、D 控制飛機移動，飛機會自動發射雷射攻擊從畫面上方出現的敵人。

遊戲加入生命值、分數、敵人血量、加速移動、重新開始、背景音樂與射擊音效等功能，
並設計科幻風格 HUD 顯示目前分數與生命狀態。

## Demo

YouTube Gameplay Demo:  
https://youtu.be/7hnAZvnEaGo

## Project Preview

![Space Shooter Game](game-preview.png)

## Gameplay

- Use W / A / S / D to move the player aircraft
- The aircraft automatically fires laser shots
- Enemies randomly appear from the top of the screen
- Each enemy has a random amount of health
- Destroying an enemy increases the score by 1
- Enemies gradually accelerate while moving downward
- If an enemy reaches the bottom of the screen, the player loses 1 life
- The player starts with 10 lives
- When life reaches 0, the game ends
- Press R to restart the game

## Features

- Automatic shooting system
- Random enemy spawning
- Enemy health system
- Enemy acceleration
- Collision detection
- Score system
- Life system
- Best score tracking during the current session
- Game over and restart system
- Sci-fi HUD interface
- Background music
- Shooting sound effects

## Technologies

- Processing
- Java
- Processing Sound Library
- Object-Oriented Programming
- 2D Game Development

## Implementation

The game is organized using object-oriented programming.

### Player

The `Plane` class stores the player's position and handles aircraft rendering and boundary checking.

### Enemies

The `Enemy` class controls enemy movement, acceleration, health, collision detection, and respawning.

Each enemy is assigned a random amount of health when it is created.

### Shooting System

Bullets are represented by the `Ammo` class and stored in an `ArrayList`.

The player automatically fires at a fixed interval, and bullets are removed when they leave the screen or hit an enemy.

### HUD

The HUD displays the current score and remaining life using a sci-fi styled interface with a life bar and individual life indicators.

### Audio

The Processing Sound library is used to provide background music and shooting sound effects.

## Controls

| Key | Action |
| --- | --- |
| W | Move Up |
| A | Move Left |
| S | Move Down |
| D | Move Right |
| R | Start / Restart |

## Project Structure

```text
processing-space-shooter/
├── week16_finalproject.pde
├── sketch.properties
├── game-preview.png
└── data/
    ├── background.png
    ├── bgm.mp3
    ├── Enemy.png
    ├── Plane.png
    └── shoot.wav
