import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

/**
*  settings must be called to pass a variable to size().
*/
void settings()
{
 size(sketch_size, sketch_size); 
}

/**
*  This size value defines both the height and width of the sketch
*  as well as the size of the grid that is the "mesh". This value
*  is the only value passed, so it should always be a square window.
*/
int sketch_size = 500;

/**
*  Called once so we only render one frame.
*  This function works by creating a buffer that we will
*  call once to be drawn to the screen. To properly populate the buffer
*  you will need to specify the file you want to use, located in the ./data folder.
*
*  Object data is populated from the earlier specified file, and that ObjectData is 
*  used to create a "zmesh" map of 'PVector coordinate/ ZMeshPoint" key-value pairs
*  that we can use to calculate the pixel color value for each and every index for our draw_buffer.
*/
void setup()
{
  background(0);
  
  SquareBuffer draw_buffer = new SquareBuffer(sketch_size);
  
  String[] file = loadStrings("default_file.obj");
  
  ObjData object_data = new ObjData(file);
  ObjParser.LoadObjDataArrays(file, object_data);
  ObjParser.SetMinMax(object_data);
   
  Map<PVector, ZMeshPoint> z_mesh = new HashMap<PVector, ZMeshPoint>();
  
  PopulateZMesh(z_mesh, object_data, draw_buffer.buffer_width);
  WriteSquareBuffer(z_mesh, draw_buffer);
  Render(draw_buffer);
}

/**
*
*
*
*/
void PopulateZMesh(Map<PVector, ZMeshPoint> z_mesh, ObjData object_data, int buffer_width)
{
  System.out.println("Populating Z Mesh...");
  
  int texels_amt = object_data.texels.length;
 
  for(int texel_index = 0; texel_index < texels_amt; texel_index = texel_index + 2){
    ZMeshPoint z_mesh_point = new ZMeshPoint();
    int x = (int)(buffer_width * object_data.texels[texel_index + 0]);
    int y = (int)(buffer_width * object_data.texels[texel_index + 1]);
    PVector buffer_coords = new PVector(x, y);
    System.out.println("    At texel index " + (texel_index / 2) + ", Creating map key " + (int)buffer_coords.x + " " + (int)buffer_coords.y);
    ZMesh.PopulateZMeshPoint(z_mesh_point, texel_index, buffer_width, object_data);
    z_mesh.put(buffer_coords, z_mesh_point);
  }
  
  System.out.println("Populating complete...");
}

/**
*  Draws image one pixel at a time for each color value that exists in buffer.
*
*  @param draw_buffer The buffer object that should be rendered.
*/
void Render(SquareBuffer draw_buffer){
  int buffer_size = draw_buffer.length;
  loadPixels();
  
  for(int index = 0; index < buffer_size; index++){
    DrawPixel(index, draw_buffer, pixels);
  }
  updatePixels();
}

/**
*  Sets pixel color value of pixel array to color value found at the same index in the draw_buffer.
*
*  @param index Index of pixel and draw_buffer to be loaded
*  @param draw_buffer color_value buffer to draw
*  @param pixel Processing array of pixels
*/
void DrawPixel(int index, SquareBuffer draw_buffer, color[] pixel){
  pixel[index] = color(draw_buffer.pixel_array[index]);
}
