import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

void setup(){
  size(200, 200);
  
  SquareBuffer draw_buffer = new SquareBuffer(width);
  
  String[] file = loadStrings("default_file.obj");
  
  ObjData object_data = new ObjData(file);
  LoadDataArrays(file, object_data);
  SetMinMax(object_data);
  
  Map<PVector, ZMeshPoint> z_mesh = new HashMap<PVector, ZMeshPoint>();
  
  PopulateZMesh(z_mesh, object_data, draw_buffer.grid_width);
  WriteSquareBuffer(z_mesh, draw_buffer);
  Render(draw_buffer);
}

void PopulateZMesh(Map<PVector, ZMeshPoint> z_mesh, ObjData object_data, int buffer_width){
  ZMeshPoint z_mesh_point = new ZMeshPoint();
  int texels_amt = object_data.texels.length;
  
  for(int texel_index = 0; texel_index < texels_amt; texel_index = texel_index + 2){
    int x = (int)(buffer_width * object_data.texels[texel_index + 0]);
    int y = (int)(buffer_width * object_data.texels[texel_index + 1]);
    PVector buffer_coords = new PVector(x, y);
    PopulateZMeshPoint(z_mesh_point, texel_index, buffer_width, object_data);
    z_mesh.put(buffer_coords, z_mesh_point);
  }
}

void Render(SquareBuffer draw_buffer){
  int buffer_size = draw_buffer.length;
  loadPixels();
  
  for(int index = 0; index < buffer_size; index++){
    DrawPixel(index, draw_buffer, pixels);
  }
  updatePixels();
}

void DrawPixel(int index, SquareBuffer draw_buffer, color[] pixel){
  pixel[index] = color(draw_buffer.grid[index]);
}
