class ZMeshPoint{
  public float[] vertex = new float[3];
  public float[] texel = new float[2];
  public float[] normal = new float[3];
  public float raw_magnitude;
  public float real_magnitude;
  public float color_magnitude;
  public Vector<int[]> shared_faces;
}

void PopulateZMeshPoint(ZMeshPoint z_mesh_point, int texel_index, int buffer_width, ObjData object_data){
  int faces_amt = object_data.faces.length;
  
  z_mesh_point.texel = new float[]{
    object_data.texels[texel_index + 0],
    object_data.texels[texel_index + 1]
  };
  
  int vertex_index = GetVertexIndex(object_data, texel_index, faces_amt);

  z_mesh_point.vertex = new float[]{
    object_data.vertices[vertex_index + 0],
    object_data.vertices[vertex_index + 1],
    object_data.vertices[vertex_index + 2]
  };
  
  int normal_index = GetNormalIndex(object_data, texel_index, faces_amt);
  
  z_mesh_point.normal = new float[]{
    object_data.normals[normal_index + 0],
    object_data.normals[normal_index + 1],
    object_data.normals[normal_index + 2]
  };
  
  PVector vertex = new PVector(
    z_mesh_point.vertex[0],
    z_mesh_point.vertex[1],
    z_mesh_point.vertex[2]
  );
  
  z_mesh_point.raw_magnitude = vertex.mag();
  z_mesh_point.real_magnitude = (z_mesh_point.raw_magnitude - object_data.min_max[0]) / object_data.magnitude_range;
  z_mesh_point.color_magnitude = 255 * z_mesh_point.real_magnitude;
  
  Vector<int[]> shared_face_data = GetSharedFaces(object_data, texel_index, faces_amt);
  z_mesh_point.shared_faces = PopulateSharedFaces(object_data, shared_face_data, buffer_width);
}

Vector<int[]> PopulateSharedFaces(ObjData object_data, Vector<int[]> shared_faces_data, int buffer_width){
  Vector<int[]> shared_faces = new Vector<int[]>();
  
  for(int vector_index = 0; vector_index < shared_faces_data.size(); vector_index++){
    int x1, y1, m1, x2, y2, m2, x3, y3, m3;
    
    int texel_1_index, vertex_1_index;
    texel_1_index = shared_faces_data.get(vector_index)[1];
    vertex_1_index = shared_faces_data.get(vector_index)[0];
    x1 = (int)(buffer_width * object_data.texels[(texel_1_index * 2) + 0]);
    y1 = (int)(buffer_width * object_data.texels[(texel_1_index * 2) + 1]);
    float raw_mag_1 = new PVector(
      object_data.vertices[(vertex_1_index * 3) + 0],
      object_data.vertices[(vertex_1_index * 3) + 1],
      object_data.vertices[(vertex_1_index * 3) + 2]
    ).mag();
    m1 = (int)(raw_mag_1 * 255);
    
    int texel_2_index, vertex_2_index;
    texel_2_index = shared_faces_data.get(vector_index)[4];
    vertex_2_index = shared_faces_data.get(vector_index)[3];
    x2 = (int)(buffer_width * object_data.texels[(texel_2_index * 2) + 0]);
    y2 = (int)(buffer_width * object_data.texels[(texel_2_index * 2) + 1]);
    float raw_mag_2 = new PVector(
      object_data.vertices[(vertex_2_index * 3) + 0],
      object_data.vertices[(vertex_2_index * 3) + 1],
      object_data.vertices[(vertex_2_index * 3) + 2]
    ).mag();
    m2 = (int)(raw_mag_2 * 255);
    
    int texel_3_index, vertex_3_index;
    texel_3_index = shared_faces_data.get(vector_index)[7];
    vertex_3_index = shared_faces_data.get(vector_index)[6];
    x3 = (int)(buffer_width * object_data.texels[(texel_3_index * 2) + 0]);
    y3 = (int)(buffer_width * object_data.texels[(texel_3_index * 2) + 1]);
    float raw_mag_3 = new PVector(
      object_data.vertices[(vertex_3_index * 3) + 0],
      object_data.vertices[(vertex_3_index * 3) + 1],
      object_data.vertices[(vertex_3_index * 3) + 2]
    ).mag();
    m3 = (int)(raw_mag_3 * 255);
    
    shared_faces.add(new int[] {
      x1, y1, m1, x2, y2, m2, x3, y3, m3
    });
  }
  return shared_faces;
}

Vector<int[]> GetSharedFaces(ObjData object_data, int texel_index, int faces_amt){
  Vector<int[]> shared_faces = new Vector<int[]>();
  
  int[] face = new int[9];
  for(int faces_index = 0; faces_index < faces_amt; faces_index = faces_index + 9) {
    if(object_data.faces[faces_index + 1] == texel_index){
      System.arraycopy(object_data.faces, faces_index, face, 0, 9);
    } else if (object_data.faces[faces_index + 4] == texel_index) {
      System.arraycopy(object_data.faces, faces_index, face, 0, 9);
    } else if (object_data.faces[faces_index + 7] == texel_index) {
      System.arraycopy(object_data.faces, faces_index, face, 0, 9);
    }
    shared_faces.add(face);
  }
  return shared_faces;
}

int GetNormalIndex(ObjData object_data, int texel_index, int faces_amt){
  int normal_index = 0;
  for(int faces_index = 0; faces_index < faces_amt; faces_index = faces_index + 9) {
    if(object_data.faces[faces_index + 1] == texel_index){
      normal_index = object_data.faces[faces_index + 2];
    } else if (object_data.faces[faces_index + 4] == texel_index) {
      normal_index = object_data.faces[faces_index + 5];
    } else if (object_data.faces[faces_index + 7] == texel_index) {
      normal_index = object_data.faces[faces_index + 8];
    }
  }
  return normal_index;
}

int GetVertexIndex(ObjData object_data, int texel_index, int faces_amt){
  int vertex_index = 0;
  for(int faces_index = 0; faces_index < faces_amt; faces_index = faces_index + 9) {
    if(object_data.faces[faces_index + 1] == texel_index){
      vertex_index = object_data.faces[faces_index + 0];
    } else if (object_data.faces[faces_index + 4] == texel_index) {
      vertex_index = object_data.faces[faces_index + 3];
    } else if (object_data.faces[faces_index + 7] == texel_index) {
      vertex_index = object_data.faces[faces_index + 6];
    }
  }
  return vertex_index;
}
