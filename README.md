# Trial of Maegi

![](https://github.com/XinyaoQiu/Trial-of-Maegi/raw/master/doc/poster.png)

This is a game written in Elm, a functional programming language for front-end web development. The game combines elements of STG (shoot 'em up) and RPG (role-playing game), allowing players to control characters, shoot bullets, defeat bosses, and interact with objects in a visually appealing world. Details can be seen in our wiki.

Our cute protagonist is called Maegi.

## Authors
- Jinyan Zhang
- Xinyao Qiu
- Runze Xue
- Heng Zhao

## Getting Started

Execute the following commands in your terminal.

```bash
make all -B
```

Then open the file `index.html` with your Internet browser.

## Control

#### RPG part

Using direction keyboard to control the character's movement. Press `c` to chat with NPC or observe the objects. Press `s` to get into the STG part when the door is open. Press `b` to open the shop directly.

#### STG part

Using direction keyboard to control the character's movement. Press `z` to shoot bullets. Press `x` to exert a bomb to clear the bullets on the screen. Press or hold `Shift` to slow down the motion of self. Press `Esc` to resume or quit.

## Core Features

The game includes the following core features:

#### STG

- Bullets: players can shoot bullets and dodge bullets shot by the boss.
- Boss: players must beat the boss to complete each level.
- Level: players progress through different levels, facing increasingly difficult challenges.

#### RPG

- Characters: players can move characters anywhere and interact with other characters and objects in the game.
- Interaction: players can touch objects to learn more about them.
- Plot: the game includes a storyline with dialogues and interactions between characters.

## Design

The game includes various design elements to enhance the gaming experience:

#### STG

- Bullets trajectories: bullets can have fixed or random trajectories, be scattered or tracked, and move in odd or even ways.
- Life: players have a life bar that decreases when hit by bullets or boss attacks. The boss also has a life bar that must be depleted to win.
- Bomb: players can use bombs to clear all bullets and deal damage to the boss.
- Slowing movements: players can slow down their movement speed to avoid bullets more easily.

#### RPG

- Visual effects: the game includes custom graphics for bullets, bosses, characters, objects, and backgrounds.
- Scene change: players can pass through doors to change the scene and progress through the game.
- Communication box: players can interact with characters through a communication box that displays text messages.

#### Extra

- BGM: the game includes background music to enhance the atmosphere.
- Help and About us: players can access information about the game and its creators.

## Video

Here is our [promotional video](https://github.com/XinyaoQiu/Trial-of-Maegi/raw/master/doc/trailer.mp4).

## License

This project is licensed under the MIT license.
