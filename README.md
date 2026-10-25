# Fruit Madness

A small Adobe Flash arcade game. A panda in a flying saucer dodges waves of angry fruit and collects muffins to keep the fuel tank from running dry. This is my first project, written in ActionScript 3 in 2013 before applying to university. It is unfinished but fully playable.

Flash is gone, so the game was remade in HTML5 with the same artwork, music and physics. The remaster is at [leinstay/fruit-madness-remastered](https://github.com/leinstay/fruit-madness-remastered) and runs in the browser.

https://user-images.githubusercontent.com/8215580/202763173-94a21118-3649-4456-9ef5-be83e6bd5f0b.mp4

## Running

`FruitMadness.swf` is the built game. It runs in a standalone Flash Player projector or in [Ruffle](https://ruffle.rs/). To rebuild, open `FruitMadness.fla` in Adobe Flash Professional CS6 or Adobe Animate and publish.

## Layout

```
FruitMadness.fla               the Flash source document with artwork, sounds and timeline
AuthortimeSharedAssets.fla     shared library assets
classes/
  DocumentClass.as             entry point
  GameLoop.as                  the frame loop (spawning, movement, collisions, score)
  Player.as, PilotPanda.as     the saucer and its pilot
  Enemies.as, Sugar.as         fruit attacks and muffins
  Explosion.as, Star.as        effects and the starfield
  Menu.as, StartEvent.as       title screen and start sequence
  PPCDetection.as              pixel-perfect collision detection
```

## License and credits

MIT License, see [LICENSE](LICENSE).
