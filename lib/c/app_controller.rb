require "opengl";

WINDOW_WIDTH  = 640
WINDOW_HEIGHT = 400
class AppController

  def display
    Gl.glClear(GL_COLOR_BUFFER_BIT)
    Gl.glFlush
  end

  def resize(w,h)
    Glut.glutReshapeWindow(WINDOW_WIDTH, WINDOW_HEIGHT)
  end

  def initialize
    Glut.glutInitWindowPosition(100, 100)
    Glut.glutInitWindowSize(WINDOW_WIDTH, WINDOW_HEIGHT)
    Glut.glutInit
    Glut.glutInitDisplayMode( GLUT::GLUT_RGB )

    Glut.glutCreateWindow("Biotope")
    Glut.glutDisplayFunc(method(:display).to_proc)
    Glut.glutReshapeFunc(method(:resize).to_proc)

    Gl.glClearColor(0.0, 0.0, 0.0, 1.0)
  end

  def run
    Glut.glutMainLoop
  end

end
