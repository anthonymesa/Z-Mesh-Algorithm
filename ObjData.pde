class ObjData{
  public float[] vertices;
  public float[] texels;
  public float[] normals;
  public int[] faces;
  public float[] min_max = new float[] {99999.0, 0.0};
  public float magnitude_range;
  
  public ObjData(String[] file){
    int[] count = new int[4];
  
    for(int i = 0; i < file.length; i++){
      String head = file[i].substring(0, 2);
    
      if(head.equals("v ")){
       count[0]++;
      } else if (head.equals("vt")){
       count[1]++;
      } else if (head.equals("vn")){
       count[2]++;
      } else if (head.equals("f ")){
       count[3]++;
      }
    }
  
    this.vertices = new float[count[0] * 3];
    this.texels = new float[count[1] * 2];
    this.normals = new float[count[2] * 3];
    this.faces = new int[(count[3] * 3) * 3];
  }
}
