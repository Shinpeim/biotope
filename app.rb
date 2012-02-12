root = File.dirname(__FILE__)
$LOAD_PATH.unshift File.join(root, 'lib')
 require "c/app_controller"

AppController.new.run
