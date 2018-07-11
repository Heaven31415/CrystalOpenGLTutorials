#
# OpenGL drawing example using GLFW
# Created by Heaven31415 <Heaven31415@gmail.com>
# Based on: https://open.gl/drawing
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
  FALSE = 0u32
  TRUE = 1u32
  ARRAY_BUFFER = 0x8892u32
  STATIC_DRAW = 0x88E4u32
  VERTEX_SHADER = 0x8B31u32
  FRAGMENT_SHADER = 0x8B30u32
  COMPILE_STATUS = 0x8B81u32
  FLOAT = 0x1406u32
  TRIANGLES	= 0x0004u32
  fun get_error = glGetError() : UInt32
  fun gen_buffers = glGenBuffers(n : Int32, buffers : UInt32*) : Void
  fun bind_buffer = glBindBuffer(target : UInt32, buffer : UInt32) : Void
  fun buffer_data = glBufferData(target : UInt32, size : Int32, data : Void*, usage : UInt32) : Void
  fun create_shader = glCreateShader(shader_type : UInt32) : UInt32
  fun shader_source = glShaderSource(shader : UInt32, count : Int32, string : UInt8**, length : Int32*) : Void
  fun compile_shader = glCompileShader(shader : UInt32) : Void
  fun get_shader_iv = glGetShaderiv(shader : UInt32, pname : UInt32, params : Int32*) : Void
  fun get_shader_info_log = glGetShaderInfoLog(shader : UInt32, max_length : Int32, length : Int32*, info_log : UInt8*) : Void
  fun create_program = glCreateProgram() : UInt32
  fun attach_shader = glAttachShader(program : UInt32, shader : UInt32) : Void
  fun link_program = glLinkProgram(program : UInt32) : Void
  fun use_program = glUseProgram(program : UInt32) : Void
  fun get_attrib_location = glGetAttribLocation(program : UInt32, name : UInt8*) : Int32
  fun vertex_attrib_pointer = glVertexAttribPointer(index : UInt32, size : Int32, type : UInt32, normalized : UInt8, stride : Int32, pointer : Void*) : Void
  fun enable_vertex_attrib_array = glEnableVertexAttribArray(index : UInt32) : Void
  fun gen_vertex_arrays = glGenVertexArrays(n : Int32, arrays : UInt32*) : Void
  fun bind_vertex_array = glBindVertexArray(array : UInt32) : Void
  fun draw_arrays = glDrawArrays(mode : UInt32, first : Int32, count : Int32) : Void
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
  # GL.get_error() # GLEW will always throw 0x500 GL_INVALID_ENUM, that's why I'm clearing it

  vertices = [
     0.0f32,  0.5f32,
     0.5f32, -0.5f32,
    -0.5f32, -0.5f32
  ]
  
  GL.gen_buffers(1, out vbo)
  GL.bind_buffer(GL::ARRAY_BUFFER, vbo)
  GL.buffer_data(GL::ARRAY_BUFFER, 6 * sizeof(Float32), vertices, GL::STATIC_DRAW)

  vertex_shader_source = <<-VERTEX_SHADER
  #version 150 core
  in vec2 position;

  void main()
  {
    gl_Position = vec4(position, 0.0, 1.0);
  }
  VERTEX_SHADER

  fragment_shader_source = <<-FRAGMENT_SHADER
  #version 150 core
  out vec4 outColor;

  void main()
  {
    outColor = vec4(1.0, 1.0, 1.0, 1.0);
  }
  FRAGMENT_SHADER
  
  vertex_shader = GL.create_shader(GL::VERTEX_SHADER)
  vertex_shader_source_pointer = vertex_shader_source.to_unsafe
  GL.shader_source(vertex_shader, 1, pointerof(vertex_shader_source_pointer), nil)
  GL.compile_shader(vertex_shader)

  GL.get_shader_iv(vertex_shader, GL::COMPILE_STATUS, out vertex_status)
  if vertex_status == GL::TRUE
    puts "Vertex shader was compiled successfully!"
  else
    buffer = uninitialized UInt8[512]
    GL.get_shader_info_log(vertex_shader, 512, nil, buffer)
    info_log = String.new(buffer.to_unsafe)
    puts info_log
  end

  fragment_shader = GL.create_shader(GL::FRAGMENT_SHADER)
  fragment_shader_source_pointer = fragment_shader_source.to_unsafe
  GL.shader_source(fragment_shader, 1, pointerof(fragment_shader_source_pointer), nil)
  GL.compile_shader(fragment_shader)

  GL.get_shader_iv(fragment_shader, GL::COMPILE_STATUS, out fragment_status)
  if fragment_status == GL::TRUE
    puts "Fragment shader was compiled successfully!"
  else
    fragment_buffer = uninitialized UInt8[512]
    GL.get_shader_info_log(fragment_shader, 512, nil, fragment_buffer)
    info_log = String.new(fragment_buffer.to_unsafe)
    puts info_log
  end

  shader_program = GL.create_program()
  GL.attach_shader(shader_program, vertex_shader)
  GL.attach_shader(shader_program, fragment_shader)
  GL.link_program(shader_program)
  GL.use_program(shader_program)

  GL.gen_vertex_arrays(1, out vao)
  GL.bind_vertex_array(vao)

  pos_attrib = GL.get_attrib_location(shader_program, "position")
  GL.vertex_attrib_pointer(pos_attrib, 2, GL::FLOAT, GL::FALSE, 0, nil)
  GL.enable_vertex_attrib_array(pos_attrib)
  GL.draw_arrays(GL::TRIANGLES, 0, 3)

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