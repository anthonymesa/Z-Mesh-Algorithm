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
  System.out.println("Writing buffer...");
  
  int buffer_width = draw_buffer.buffer_width;
  PVector anchor_node = new PVector(0, 0);
  PVector traverse_node = new PVector(0, 0);
  
  for(int y = 0; y < buffer_width; y++)
  {
    if(z_mesh.containsKey(new PVector(0, y)))
    {
      anchor_node.set(new PVector(0, y));
    }
    
    traverse_node.set(anchor_node);
    
    for(int x = 0; x < buffer_width; x++)
    {
      PVector buffer_coords = new PVector(x, y);
      
      if(z_mesh.containsKey(buffer_coords))
      {
        traverse_node.set(buffer_coords);
        int[] face = GetFace(buffer_coords, z_mesh.get(traverse_node).shared_faces);
        CalculatePixelColor(face, buffer_coords, draw_buffer, buffer_width);
      }
      else
      {
        int[] face = GetFace(buffer_coords, z_mesh.get(traverse_node).shared_faces);
          
        if(face != null)
        {   
            CalculatePixelColor(face, buffer_coords, draw_buffer, buffer_width);
        }
        else
        {
            for(PVector node : z_mesh.get(traverse_node).shared_nodes)
            {
              face = GetFace(buffer_coords, z_mesh.get(node).shared_faces);
              
              if(face != null)
              {   
                  CalculatePixelColor(face, buffer_coords, draw_buffer, buffer_width);
                  traverse_node.set(node);
              }
            }
        }
      }
    }
  }
}

//void WriteSquareBuffer(Map<PVector, ZMeshPoint> z_mesh, SquareBuffer draw_buffer){
//  System.out.println("Writing buffer...");
//  int buffer_width = draw_buffer.buffer_width;
  
//  PVector row_anchor = new PVector(0, 0);
//  PVector column_anchor = new PVector(0, 0);

//  for(int y = 0; y < buffer_width; y++)
//  {
    
//    if(z_mesh.containsKey(new PVector(0, y)))
//    {
//        row_anchor.set(0, y);
//    }

//    column_anchor.set(row_anchor.x, row_anchor.y);
//    System.out.println("new row anchor at (" + row_anchor.x + " " + row_anchor.y + ")");
//    System.out.println("new column anchor at (" + column_anchor.x + " " + column_anchor.y + ")");
    
//    for(int x = 0; x < buffer_width; x++)
//    {
//        PVector z_mesh_key = new PVector(x, y);

//        if(z_mesh.containsKey(z_mesh_key))
//        {
//            draw_buffer.pixel_array[(y * buffer_width) + x] = (int) z_mesh.get(z_mesh_key).color_magnitude;
//            System.out.println("Calculated color from z_mesh at (" + x + " " + y + ")");
//        }
//        //else
//        //{
//        //    Algorithm(z_mesh, z_mesh_key, column_anchor, buffer_width, draw_buffer, false);
//        //}
//    }
//  }
//  System.out.println("Buffer writing complete...");
//}

//void Algorithm(Map<PVector, ZMeshPoint> z_mesh, PVector z_mesh_key, PVector column_anchor, int buffer_width, SquareBuffer draw_buffer, boolean recursion)
//{
//    if(recursion)
//    {
//        //System.out.println("recursing...");
//        AdvanceColumnAnchor(z_mesh, column_anchor, buffer_width);
//        //System.out.println("Column anchor updated: " + column_anchor.x + " " + column_anchor.y);
//    }

//    int[] face = GetFace(z_mesh_key, z_mesh.get(column_anchor).shared_faces);
      
//    if(face != null)
//    {   
//        CalculatePixelColor(face, z_mesh_key, draw_buffer, buffer_width);
//    }
//    else
//    {
//        Algorithm(z_mesh, z_mesh_key, column_anchor, buffer_width, draw_buffer, true);
//    }
//}

//void AdvanceColumnAnchor(Map<PVector, ZMeshPoint> z_mesh, PVector column_anchor, int buffer_width)
//{
//    //System.out.println("advanving column anchor...");
//    PVector new_column_anchor = new PVector(column_anchor.x + 1, column_anchor.y);
//    while((!z_mesh.containsKey(new_column_anchor)) && (new_column_anchor.x < buffer_width))
//    {
//        //System.out.println(new_column_anchor.x + " " + new_column_anchor.y + "\n");
//        new_column_anchor = new PVector(column_anchor.x + 1, column_anchor.y);
//        column_anchor.set(new_column_anchor.x, new_column_anchor.y);
//    }
//}

int[] GetFace(PVector z_mesh_key, Vector<int[]> shared_faces)
{
    for(int i = 0; i < shared_faces.size(); i++)
    {
        PVector a = new PVector(shared_faces.get(i)[0], shared_faces.get(i)[1]);
        PVector b = new PVector(shared_faces.get(i)[3], shared_faces.get(i)[4]);
        PVector c = new PVector(shared_faces.get(i)[6], shared_faces.get(i)[7]);

        float area_normal = AreaTriangle(a, b, c);
        float area_key = AreaKey(a, b, c, z_mesh_key);

        if(area_key <= area_normal)
        {
            return shared_faces.get(i);
        }
    }
    return null;
}

float AreaTriangle(PVector a, PVector b, PVector c)
{
    return Math.abs((a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y)) / 2);
}

float AreaKey(PVector a, PVector b, PVector c, PVector d)
{
    float area_1 = Math.abs((a.x * (b.y - d.y) + b.x * (d.y - a.y) + d.x * (a.y - b.y)) / 2);
    float area_2 = Math.abs((a.x * (c.y - d.y) + c.x * (d.y - a.y) + d.x * (a.y - c.y)) / 2);
    float area_3 = Math.abs((b.x * (c.y - d.y) + c.x * (d.y - b.y) + d.x * (b.y - c.y)) / 2);
    return area_1 + area_2 + area_3;
}

void CalculatePixelColor(int[] face, PVector buffer_coords, SquareBuffer draw_buffer, int buffer_width)
{
    float color_value = 0;

    PVector a = new PVector(face[0], face[1], face[2]);
    PVector b = new PVector(face[3], face[4], face[5]);
    PVector c = new PVector(face[6], face[7], face[8]);

    PVector d = PVector.sub(b, a);
    PVector e = PVector.sub(c, a);

    PVector n = d.cross(e);

    int buffer_y = (int)(buffer_coords.y * buffer_width);
    int pixel_index = buffer_y + (int)buffer_coords.x;
    
    StringBuilder output = new StringBuilder();
    output.append("face_data: " + Arrays.toString(face) + "\n");
    output.append("Point A: " + a.toString() + "\n");
    output.append("Point B: " + b.toString() + "\n");
    output.append("Point C: " + c.toString() + "\n");
    output.append("Vector A to B: " + d.toString() + "\n");
    output.append("Vector A to C: " + e.toString() + "\n");
    output.append("Normal n: " + n.toString() + "\n");
    
    color_value = -(-((a.x - buffer_coords.x) * (-n.x / -n.z))-((a.y - buffer_coords.y) * (n.y / n.z)) - a.z);
    
    output.append("Equation: -(-((" + a.x + " - " + buffer_coords.x + ") * (-" + n.x + " / -" + n.z + "))-((" + a.y + " - " + buffer_coords.y + ") * (" + n.y + " / " + n.z + ")) - " + a.z + ")\n");
    output.append("calculated color: " + (int)color_value + " at pixel index: " + pixel_index + "\n");
    //System.out.println(output);
    
    draw_buffer.pixel_array[pixel_index] = (int)color_value;
}
