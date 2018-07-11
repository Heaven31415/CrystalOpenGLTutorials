#
# OpenGL context creation example using GLFW
# Created by Heaven31415 <Heaven31415@gmail.com>
# Based on: https://open.gl/context
# 
# PLEASE READ BEFORE USE:
# 
# This code was tested successfully on both ubuntu 16.04 and 18.04 releases.
# I was able to run this example without installed GLEW, however you may need
# to install it on other operating systems (especially on Windows).
# 
# Below in the code you will find two commented sections, uncomment them if
# you are unable to run this without GLEW.
#

@[Link("glfw")]
lib GLFW
  TRUE    = 1
  FALSE   = 0
  PRESS   = 1
  RELEASE = 0
  CONTEXT_VERSION_MAJOR = 0x00022002
  CONTEXT_VERSION_MINOR = 0x00022003
  OPENGL_PROFILE        = 0x00022008
  OPENGL_FORWARD_COMPAT = 0x00022006
  OPENGL_CORE_PROFILE   = 0x00032001
  RESIZABLE             = 0x00020003
  KEY_ESCAPE            = 256

  fun init = glfwInit() : Int32
  fun terminate = glfwTerminate() : Void
  fun hint = glfwWindowHint(hint : Int32, value : Int32) : Void
  fun create_window = glfwCreateWindow(width : Int32, height : Int32, title : UInt8*, monitor : Void*, share : Void*) : Void*
  fun make_context_current = glfwMakeContextCurrent(window : Void*) : Void
  fun window_should_close = glfwWindowShouldClose(window : Void*) : Int32
  fun swap_buffers = glfwSwapBuffers(window : Void*) : Void
  fun poll_events = glfwPollEvents() : Void
  fun get_key = glfwGetKey(window : Void*, key : Int32) : Int32
  fun set_window_should_close = glfwSetWindowShouldClose(window : Void*, value : Int32) : Void
end

# --- UNCOMMENT ME IF GLEW IS NEEDED ---
# @[Link("glew")]
# lib GLEW
#  $glewExperimental : UInt8
#  fun init = glewInit() : UInt32
# end

@[Link("GL")]
lib GL
  fun gen_buffers = glGenBuffers(n : Int32, buffers : UInt32*) : Void
end

if GLFW.init() == GLFW::TRUE
  puts "Successfully initialized GLFW!"

  GLFW.hint(GLFW::CONTEXT_VERSION_MAJOR, 3)
  GLFW.hint(GLFW::CONTEXT_VERSION_MINOR, 2)
  GLFW.hint(GLFW::OPENGL_PROFILE, GLFW::OPENGL_CORE_PROFILE)
  GLFW.hint(GLFW::OPENGL_FORWARD_COMPAT, GLFW::TRUE)
  GLFW.hint(GLFW::RESIZABLE, GLFW::FALSE)

  window = GLFW.create_window(800, 640, "openGL", nil, nil)
  GLFW.make_context_current(window)

  # --- UNCOMMENT ME IF GLEW IS NEEDED ---
  # GLEW.glewExperimental = 1u8
  # GLEW.init()

  GL.gen_buffers(1, out buffer)
  puts "Created new buffer object with name: #{buffer}"

  while GLFW.window_should_close(window) == GLFW::FALSE
    GLFW.swap_buffers(window)
    GLFW.poll_events()

    if GLFW.get_key(window, GLFW::KEY_ESCAPE) == GLFW::PRESS
      GLFW.set_window_should_close(window, GLFW::TRUE)
    end

  end

  GLFW.terminate()
else
  puts "Unable to initialize GLFW!"
end