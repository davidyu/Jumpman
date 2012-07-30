Jumpman
=======

![Buoyancy and water ripples!](/desktop/Jumpman/raw/master/Screenshots/screen.build.6.27.jpg)
![Vaulting!](/desktop/Jumpman/raw/master/Screenshots/screen.build.newest.jpg)
![Starry skies...](/desktop/Jumpman/raw/master/Screenshots/screen.build.newest2.jpg)

##Premise

Could same-machine co-op work with platformers?

+ Short answer: maybe; but not without a slick splitscreen mode or networking.
+ Long answer: try Jumpman!

##History

One of the first prototypes I spent more than a month on. I started this project just as I was starting Computer Science in college (around 2009), so I didn't try to start writing everything from scratch and instead made liberal use of (read: copied) libraries, frameworks, and code snippets from the web. As a result, the prototype features tech (like realistic buoyancy and particle emitters) that I would never have been able to build by myself at the time.

##Controls

+ Player 1: **WASD** to move and jump
+ Player 2: **↑←↓→** to move and jump
+ Camera control: **SPACEBAR** to switch focus (yes, this a manual camera -- trying to build a good camera that kept both players on-screen was both frustrating and humbling. It goes without saying that I now have a profound respect for well-implemented cameras in games)

##Authors

[David Yu](http://github.com/desktop) (code), Ben Kwok (music)

##Tools and neat tech

+ ActionScript 3
+ [Box2D Physics Engine](http://box2dflash.sourceforge.net) (+ [buoyancy](http://personal.boristhebrave.com/project/b2buoyancycontroller)!)
+ [Tweensy particles](http://code.google.com/p/tweensy/wiki/TweensyFX)
+ [Sine wave-based water ripples](http://www.senocular.com/flash/source/?id=0.28).
+ [BulkLoader](http://code.google.com/p/bulk-loader/wiki/GettingStarted): XML level loader

If you're starting out in Box2D, make sure to watch [Todd Kerpelman's Box2D tutorials](http://www.kerp.net/box2d/)