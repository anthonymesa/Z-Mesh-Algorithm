class SquareBuffer{
  public int[] pixel_array;
  public int buffer_width;
  public int length;
  
  public SquareBuffer(int size){
    final int buffer_size = size * size;
    this.pixel_array = new int[buffer_size];
    this.length = pixel_array.length;
    this.buffer_width = (int)Math.pow(this.length, .5);
  }
}

void WriteSquareBuffer(Map<PVector, ZMeshPoint> z_mesh, SquareBuffer draw_buffer){
  int buffer_length = draw_buffer.length;
  int buffer_width = draw_buffer.buffer_width;
  
  for(int y = 0; y < buffer_length; y = y + buffer_width){
    for(int x = 0; x < buffer_width; x++){
      draw_buffer.pixel_array[y + x] = CalculateColor(x, (int)(y / buffer_width), z_mesh);
    }
  }
}

int CalculateColor(int x, int y, Map<PVector, ZMeshPoint> z_mesh){
  PVector key_value = new PVector(x, y);
  
  if(z_mesh.containsKey(key_value)){
    return (int)z_mesh.get(key_value).color_magnitude;
  } else {
    return Algorithm();
  }
}

int Algorithm()
{
  return 0;
}
