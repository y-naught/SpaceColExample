import java.util.*;
Tree t;
float minDistance = 30;
float maxDistance = 2;


void setup(){
  fullScreen(P2D);
  t = new Tree(8000);
  
}

void draw(){
  background(0);
  t.show();
  t.grow();
  saveFrame("SpaceColinizationAlgorithm2-#####");
}


class Leaf{
  Random rando = new Random();
  PVector location;
  boolean reached = false;
  double num1;
  double num2;
  Leaf(){
    num1 = 700 * rando.nextGaussian() + width / 2;
    num2 = 500 * rando.nextGaussian() + height / 2;
    location = new PVector((float)num1, (float)num2);
  }
  
  
  void display(){
    if(!reached){
    fill(255);
    noStroke();
    ellipse(location.x, location.y, 5,5);
    }
  }
}

class Tree{
 
 ArrayList<Branch> branches = new ArrayList<Branch>();
 PVector rootPos;
 Branch root;
 int count;
 Leaf [] leaves;

 
 Tree(int c){
   rootPos = new PVector(width / 2, height / 2);
   PVector dir = new PVector(10, 0);
   root = new Branch(rootPos.x, rootPos.y, rootPos.x, rootPos.y, dir);
   branches.add(root);
   
   count = c;
   leaves = new Leaf[c];
   
   
   for(int i = 0; i < c; i++){
    leaves[i] = new Leaf();
   }
   
   //float dis = 5000;
   boolean found = false;
   Branch current = root;
   
   while(!found){
   for(int i = 0; i < leaves.length; i++){
     float d = PVector.dist(current.location, leaves[i].location);
     if(d < maxDistance){
      found = true;
     }
   }
   if(!found){
    PVector newLoc = new PVector(current.location.x + current.direction.x, current.location.y + current.direction.y);
    Branch br = new Branch(newLoc.x,newLoc.y, current.location.x, current.location.y, current.direction);
    current = br;
    branches.add(current);
   }
  }
 }
 
 void grow(){
  for(int i = 0; i < leaves.length; i++){
    
    Leaf l = leaves[i];
    int closestBranch = 0;
    float record = 200.0;
   for(int j = 0; j < branches.size(); j++){
     Branch br = branches.get(j);
     float d = PVector.dist(l.location, br.location);
     
     if(d < minDistance){
      l.reached = true;
      break;
     }else if(closestBranch == 0 || d < record){
       closestBranch = j;
       record = d;
     }
    }
    if(closestBranch != 0){
      PVector d = PVector.sub(leaves[i].location, branches.get(closestBranch).location);
      d.normalize();
      d.mult(10);
      branches.get(closestBranch).direction.add(d);
      branches.get(closestBranch).count++;
    }
   }
   
   for(int i = branches.size() - 1; i >= 0; i--){
     Branch br = branches.get(i);
     if(br.count > 0){
       br.direction.div(br.count);
       PVector newPos = PVector.add(br.location, br.direction);
       Branch nBr = new Branch(newPos.x, newPos.y, br.location.x, br.location.y, br.direction);
       branches.add(nBr);
     }
     br.reset();
   }
  }
 
 
 void show(){
  for(int i = 0; i < leaves.length; i ++){
   leaves[i].display();
  }
  for(int i = 0; i < branches.size(); i++){
    Branch br = branches.get(i);
    br.display(); 
  }
 }
}

class Branch{
 PVector location;
 PVector ParentPos;
 PVector direction;
 PVector originalDirection;
 int count = 0;
 
 Branch(float x, float y, float lx, float ly, PVector dir){
   location = new PVector(x,y);
   ParentPos = new PVector(lx, ly);
   direction = dir.get();
   originalDirection = direction.get();
 }
 
 void reset(){
   direction = originalDirection.get();
   count = 0;
 }
 
 void display(){
   strokeWeight(3);
   stroke(255, 150);
  line(ParentPos.x, ParentPos.y, location.x, location.y); 
 }
}