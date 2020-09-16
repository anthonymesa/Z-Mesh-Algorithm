/**
*  ZMesh is static so we can create and manipulate a large collection of ZMeshPoints without
*  copying the code to manipulate those objects across all elements of the collection.
*  (with thousands of elements, that memory builds up).
*/

public static class ZMesh
{
  /**
  *  Populates all the data for a ZMeshPoint that will be used as a value in the HashMap.
  */
  public static void PopulateZMeshPoint(ZMeshPoint z_mesh_point, int texel_index, int buffer_width, ObjData object_data) // texl index = 0, 1, 2 - buffer width = 500
  { 
    int faces_list_size = object_data.faces.length; // # of obj faces * 9 line elements in array for full array size
    // texel index = 0, faces_list_size = 192 * 9 = 1728
    int vertex_index = GetVertexIndex(object_data, texel_index, faces_list_size); // works
    //int normal_index = GetNormalIndex(object_data, texel_index, faces_list_size);
    
    //System.out.println(vertex_index + " " /* +  normal_index */);
    
    SetTexel(z_mesh_point, texel_index, object_data); // works
    SetVertex(z_mesh_point, vertex_index, object_data); // works
    
    //System.out.println(Arrays.toString(z_mesh_point.texel));
    //System.out.println(Arrays.toString(z_mesh_point.vertex));
    
    //SetNormal(z_mesh_point, normal_index, object_data);
    SetRawMagnitude(z_mesh_point); // works
    SetRealMagnitude(z_mesh_point, object_data); // works
    SetColorMagnitude(z_mesh_point); //works
    
    Vector<int[]> shared_face_data = GetSharedFaces(object_data, texel_index, faces_list_size); // works
    z_mesh_point.shared_faces = PopulateSharedFaces(object_data, shared_face_data, buffer_width); 
  }
  
  public static void SetColorMagnitude(ZMeshPoint z_mesh_point)
  {
    z_mesh_point.color_magnitude = 255 * z_mesh_point.real_magnitude; 
  }
  
  public static void SetRealMagnitude(ZMeshPoint z_mesh_point, ObjData object_data)
  {
    z_mesh_point.real_magnitude = (z_mesh_point.raw_magnitude - object_data.min_max[0]) / object_data.magnitude_range;
  }
  
  public static void SetRawMagnitude(ZMeshPoint z_mesh_point)
  {
    PVector vertex = new PVector(
      z_mesh_point.vertex[0],
      z_mesh_point.vertex[1],
      z_mesh_point.vertex[2]
    );
    
    z_mesh_point.raw_magnitude = vertex.mag();  
  }
  
  public static void SetNormal(ZMeshPoint z_mesh_point, int normal_index, ObjData object_data)
  {
    z_mesh_point.normal = new float[]{
      object_data.normals[normal_index + 0],
      object_data.normals[normal_index + 1],
      object_data.normals[normal_index + 2]
    };  
  }
  
  public static void SetTexel(ZMeshPoint z_mesh_point, int texel_index, ObjData object_data)
  {
    z_mesh_point.texel = new float[]{
      object_data.texels[(texel_index * 2) + 0],
      object_data.texels[(texel_index * 2) + 1]
    };  
  }
  
  public static void SetVertex(ZMeshPoint z_mesh_point, int vertex_index, ObjData object_data)
  {
    z_mesh_point.vertex = new float[]{
      object_data.vertices[((vertex_index - 1) * 3) + 0],
      object_data.vertices[((vertex_index - 1) * 3) + 1],
      object_data.vertices[((vertex_index - 1) * 3) + 2]
    }; 
  }
  
  public static Vector<int[]> PopulateSharedFaces(ObjData object_data, Vector<int[]> shared_faces_data, int buffer_width){ // buffer width = 500
    Vector<int[]> shared_faces = new Vector<int[]>();
    
    for(int vector_index = 0; vector_index < shared_faces_data.size(); vector_index++){ // for each array of ints (shared_face arrays) in the vector
      int[] shared_data = new int[9]; // tx1, ty1, vm1, tx2, ty2, vm2, tx3, ty3, vm3
      
      SetFaceA(shared_data, shared_faces_data, vector_index, object_data, buffer_width);
      SetFaceB(shared_data, shared_faces_data, vector_index, object_data, buffer_width);
      SetFaceC(shared_data, shared_faces_data, vector_index, object_data, buffer_width);

      shared_faces.add(shared_data);
    }
    return shared_faces;
  }
  
  public static void SetFaceA(int[] shared_data, Vector<int[]> shared_faces_data, int vector_index, ObjData object_data, int buffer_width) // vector_index = 0, 1, 2 -
  {
    int t_i = shared_faces_data.get(vector_index)[1]; // (dummy values) 67 [47] 160 10 106 160 59 104 160
    int v_i = shared_faces_data.get(vector_index)[0]; // (dummy values) [67] 47 160 10 106 160 59 104 160
    shared_data[0] = (int)(buffer_width * object_data.texels[((t_i - 1) * 2) + 0]);
    shared_data[1] = (int)(buffer_width * object_data.texels[((t_i - 1) * 2) + 1]);
    float raw_mag_vector = GetRawMag(object_data, v_i - 1);
    shared_data[2] = (int)(raw_mag_vector * 255);
  }
  
  public static void SetFaceB(int[] shared_data, Vector<int[]> shared_faces_data, int vector_index, ObjData object_data, int buffer_width)
  {
    int t_i = shared_faces_data.get(vector_index)[4];
    int v_i = shared_faces_data.get(vector_index)[3];
    shared_data[3] = (int)(buffer_width * object_data.texels[((t_i - 1) * 2) + 0]);
    shared_data[4] = (int)(buffer_width * object_data.texels[((t_i - 1) * 2) + 1]);
    float raw_mag_vector = GetRawMag(object_data, v_i - 1);
    shared_data[5] = (int)(raw_mag_vector * 255);
  }
  
  public static void SetFaceC(int[] shared_data, Vector<int[]> shared_faces_data, int vector_index, ObjData object_data, int buffer_width)
  {
    int t_i = shared_faces_data.get(vector_index)[7];
    int v_i = shared_faces_data.get(vector_index)[6];
    shared_data[6] = (int)(buffer_width * object_data.texels[((t_i - 1) * 2) + 0]);
    shared_data[7] = (int)(buffer_width * object_data.texels[((t_i - 1) * 2) + 1]);
    float raw_mag_vector = GetRawMag(object_data, v_i - 1);
    shared_data[8] = (int)(raw_mag_vector * 255);
  }
  
  public static float GetRawMag(ObjData object_data, int v_i)
  {
    return new PVector(
      object_data.vertices[(v_i * 3) + 0],
      object_data.vertices[(v_i * 3) + 1],
      object_data.vertices[(v_i * 3) + 2]
    ).mag();
  }
  
  public static Vector<int[]> GetSharedFaces(ObjData object_data, int texel_index, int faces_list_size) // texl index = 0, 1, 2 -  faces_list_size = 1728
  {
    Vector<int[]> shared_faces = new Vector<int[]>();
    
    for(int faces_index = 0; faces_index < faces_list_size; faces_index = faces_index + 9) // runs from faces_index = 0 to faces_index = 1728
    {
      int[] face = new int[9];
      if(object_data.faces[faces_index + 1] == ((texel_index) + 1)){
        System.arraycopy(object_data.faces, faces_index, face, 0, 9);
        shared_faces.add(face);
      } else if (object_data.faces[faces_index + 4] == ((texel_index) + 1)) {
        System.arraycopy(object_data.faces, faces_index, face, 0, 9);
        shared_faces.add(face);
      } else if (object_data.faces[faces_index + 7] == ((texel_index) + 1)) {
        System.arraycopy(object_data.faces, faces_index, face, 0, 9);
        shared_faces.add(face);
      }
    }
    for(int[] each_face : shared_faces)
    {
      //System.out.println(Arrays.toString(each_face)); 
    }
    return shared_faces;
  }
  
  /** 
  *  Reads through all faces in ObjData and returns the normal index if given texel 
  *  index exists in the three vertices of that face.
  */
  public static int GetNormalIndex(ObjData object_data, int texel_index, int faces_array_size){
    int normal_index = 0;
    for(int faces_index = 0; faces_index < faces_array_size; faces_index = faces_index + 9) {
      if(object_data.faces[faces_index + 1] == (texel_index + 1)){
        normal_index = object_data.faces[faces_index + 2];
      } else if (object_data.faces[faces_index + 4] == (texel_index + 1)) {
        normal_index = object_data.faces[faces_index + 5];
      } else if (object_data.faces[faces_index + 7] == (texel_index + 1)) {
        normal_index = object_data.faces[faces_index + 8];
      }
    }
    return normal_index;
  }
  
  /** 
  *  Reads through all faces in ObjData and returns the vertex index if given texel 
  *  index exists in the three vertices of that face.
  */
  public static int GetVertexIndex(ObjData object_data, int texel_index, int faces_array_size){ // texl index = 0, 1, 2 - faces_list_size = 192 * 9 = 1728
    int vertex_index = 0;
    for(int faces_index = 0; faces_index < faces_array_size; faces_index = faces_index + 9) { // runs from faces_index = 0 to faces_index = 1728
      if(object_data.faces[faces_index + 1] == (texel_index + 1)){ // if the value at faces_index + 1, 4, 7 (the location in each face info of the texel index) = the current (texel index + 1) [there are no zeros in the data]
        vertex_index = object_data.faces[faces_index + 0];
      } else if (object_data.faces[faces_index + 4] == (texel_index + 1)) {
        vertex_index = object_data.faces[faces_index + 3];
      } else if (object_data.faces[faces_index + 7] == (texel_index + 1)) {
        vertex_index = object_data.faces[faces_index + 6];
      }
    }
    return vertex_index;
  }  
}
