class SquareBuffer{
  public int[] grid;
  public int grid_width;
  public int length;
  
  public SquareBuffer(int size){
    final int grid_size = size * size;
    this.grid = new int[grid_size];
    this.length = grid.length;
    this.grid_width = (int)Math.pow(this.length, .5);
  }
}

void WriteSquareBuffer(Map<PVector, ZMeshPoint> z_mesh, SquareBuffer draw_buffer){
  int buffer_length = draw_buffer.length;
  int buffer_width = draw_buffer.grid_width;
  
  for(int y = 0; y < buffer_length; y = y + buffer_width){
    for(int x = 0; x < buffer_width; x++){
      draw_buffer.grid[y + x] = CalculateColor(x, (int)(y / buffer_width), z_mesh);
    }
  }
}

int CalculateColor(int x, int y, Map<PVector, ZMeshPoint> z_mesh){
  PVector key_value = new PVector(x, y);
  
  if(z_mesh.containsKey(key_value)){
    return 255;
  } else {
    return 0;
  }
}
