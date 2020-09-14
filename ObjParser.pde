public static class ObjParser
{  
  public static void LoadObjDataArrays(String[] file, ObjData object_data){
    System.out.println("Loading Object Data arrays...");
    int[] count = new int[4];
    
    for(int i = 0; i < file.length; i++){
      String head = file[i].substring(0, 2);
      
      if(head.equals("v ")){
        ParseVertex(count[0]++, file[i], object_data);
      } else if (head.equals("vt")){
        ParseTexel(count[1]++, file[i], object_data);
      } else if (head.equals("vn")){
        ParseNormal(count[2]++, file[i], object_data);
      } else if (head.equals("f ")){
        ParseFace(count[3]++, file[i], object_data);
      }
    }
  }
  
  public static void SetMinMax(ObjData object_data){
    System.out.println("Setting Min/Max...");
    int vertices_amt = object_data.vertices.length;
    
    for(int vertex_index = 0; vertex_index < vertices_amt; vertex_index = vertex_index + 3){
      float vertex_magnitude = new PVector(
        object_data.vertices[vertex_index + 0],
        object_data.vertices[vertex_index + 1],
        object_data.vertices[vertex_index + 2]
      ).mag();
      
      float min = object_data.min_max[0];
      float max = object_data.min_max[1];
      
      if(vertex_magnitude < min){
        object_data.min_max[0] = vertex_magnitude;
      }
      if (vertex_magnitude > max){
        object_data.min_max[1] = vertex_magnitude;
      }
    }
    
    object_data.magnitude_range = object_data.min_max[1] - object_data.min_max[0];
  }
  
  public static void ParseVertex(int i, String line, ObjData object_data){
    String[] line_items = line.substring(2).trim().split(" ");
    
    for(int k = 0; k < line_items.length; k++){
      object_data.vertices[(i * 3) + k] = Float.parseFloat(line_items[k]);
    }
  }
  
  public static void ParseTexel(int i, String line, ObjData object_data){
    String[] line_items = line.substring(2).trim().split(" ");
    
    for(int k = 0; k < line_items.length; k++){
      object_data.texels[(i * 2) + k] = Float.parseFloat(line_items[k]);
    }
  }
  
  public static void ParseNormal(int i, String line, ObjData object_data){
    String[] line_items = line.substring(2).trim().split(" ");
    
    for(int k = 0; k < line_items.length; k++){
      object_data.normals[(i * 3) + k] = Float.parseFloat(line_items[k]);
    }
  }
  
  public static void ParseFace(int i, String line, ObjData object_data){
    String[] line_items = line.substring(2).trim().split(" ");
    
    for(int k = 0; k < line_items.length; k++){
      String[] point = line_items[k].split("/");
      
      for(int j = 0; j < point.length; j++){
        object_data.faces[(i * 9) + (k * 3) + j] = Integer.parseInt(point[j]);
      }
    }
  } 
}
