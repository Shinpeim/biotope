# biotope

## ABOUT THIS SOFTWARE / このソフトについて

This software is a biotope simulator written in ruby with OpenGL.

RubyとOpenGLで書かれた、生態系シミュレータです。

## ABOUT COLORED RECTANGLE / 色付きの四角について

### green rectangle / 緑の四角

a green rectangle represent some grass. grass can't move, of course.

緑の四角は草です。もちろんうごきません。

### yellow rectangle / 黄色の四角

a yellow rectangle represent a herbivore. herbivore can move. it move randomly.

黄色の四角は草食動物です。ランダムウォークします。


## TODO / 今後の予定

* herbivores must be die and then change into some grasses / 草食動物に死を用意する。死んだら草になる
* herbivores must eat grass. / 草食動物は草を捕食する。
* herbivores will breed. / 草食動物は繁殖する。
* create carnivores / 肉食動物作る
* map textures to living things / 生き物にテクスチャ貼る

## HOW TO INSTALL

    $ cd /path/to/biotope
    $ bundel install
    $ bundle exec ruby app.rb