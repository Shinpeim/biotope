# biotope

## ABOUT THIS SOFTWARE / このソフトについて

This software is a biotope simulator written in ruby with OpenGL.

RubyとOpenGLで書かれた、生態系シミュレータです。

## ABOUT COLORED RECTANGLE / 色付きの四角について

### green rectangle / 緑の四角

a green rectangle represent grass. grass can't move, of course.

緑の四角は草です。もちろんうごきません。

### yellow rectangle / 黄色の四角

a yellow rectangle represent a herbivore. herbivore can move. it move randomly. get hungly to be dead. once dead, it turn into some grass

黄色の四角は草食動物です。ランダムウォークします。おなかが減ると死にます。死ぬと草になります。

### red rectangle / 赤の四角

a red rectangle represent a canivore. carnivore can move. it move randomly. get hungly to be dead. once dead, it turn into some grass

赤の四角は肉食動物です。ランダムウォークします。おなかが減ると死にます。死ぬと草になります。


## TODO / 今後の予定

* map textures to living things / 生き物にテクスチャ貼る

## HOW TO INSTALL

    $ cd /path/to/biotope
    $ bundel install
    $ bundle exec ruby app.rb