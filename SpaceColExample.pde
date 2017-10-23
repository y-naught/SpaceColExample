import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

import java.util.*;

PeasyCam cam;

Tree t;
float minDistance = 100;
float maxDistance = 10;

boolean pointsOn = true;
boolean treeMode = true;

void setup(){
  fullScreen(P3D);
  t = new Tree(10);
  //cam = new PeasyCam(this,0,0,0,500);
}

void draw(){
  background(0);
  translate(-width / 2, -height / 2, 0);
  t.show();
  t.grow();
  //saveFrame("SpaceColinizationAlgorithm2-#####");
}

void keyPressed(){
 if(key == ' '){
  if(!pointsOn){
   pointsOn = true; 
  }
  else{
   pointsOn = false; 
  }
 }
 else if(key == 't'){
  if(!treeMode){
   treeMode = true; 
  }
  else{
   treeMode = false; 
  }
 }
}


class Leaf{
  Random rando = new Random();
  PVector location;
  boolean reached = false;
  double num1;
  double num2;
  double num3;
  float spreadX;
  float spreadY;
  float spreadZ;
  
  Leaf(){
    
    if(treeMode){
    spreadX = 80;
    spreadY = 150;
    spreadZ = 80;
    
    num2 = spreadY * rando.nextGaussian() + height / 2;
    num3 = spreadZ * rando.nextGaussian() + height / 2;
    
    float yRange = (height / 2 + spreadY) - (height / 2 - spreadY);
    if(map((float)num2, height / 2 - yRange / 2, height / 2 + yRange/2, 0, yRange) < 1 * yRange / 6){
      float std;
      std = map(log10(abs((float)num2)), 0, 3, 0, 1.0);
      //println(std);
      num1 = std * spreadX * rando.nextGaussian() + width / 2;
    }
    
    else if(map((float)num2, height / 2 - yRange / 2, height / 2 + yRange/2, 0, yRange) >= 1 * yRange / 6 && map((float)num2, height / 2 - yRange / 2, height / 2 + yRange/2, 0, yRange) < 5 * yRange / 6){
      float std;
      std = pow((float)num2, 1 / 3.0);
      std = map(std, 1, 33, 1, 4);
      //println(std);
      num1 = std * spreadX * rando.nextGaussian() + width / 2;
    }
    
    else if(map((float)num2, height / 2 - yRange / 2, height / 2 + yRange/2, 0, yRange) >= 5 * yRange / 6){
      float std;
      std = -pow((float)num2, 2) + 4;
      std = map(std,0, pow(yRange, 2) , 0.125, 0);
      //println(std);
      num1 = std * spreadX * rando.nextGaussian() + width / 2;
    }
    
    location = new PVector((float)num1, (float)num2);
    }
    //else{
    //  spreadX = 200;
    //  spreadY = 200;
    //  spreadZ = 200;
      
    //  num1 = spreadX * rando.nextGaussian() + width / 2;
    //  num3 = spreadZ * rando.nextGaussian() + height / 2;
    //  //float dif = (abs((float)num1 - width / 2) + abs((float)num3 - height / 2)) / 2;
    //  //num2 = map(dif, 0, 100, 0, 100); 
    //  num2 = spreadY * rando.nextGaussian() + height / 2;
      
    //  location = new PVector((float)num1, (float)num2, (float)num3);
    //}
    else{
     location = PVector.random3D(); 
     location.mult(width / 2);
    }
   }
  
  
  
  void display(){
    if(!reached){
    fill(255);
    noStroke();
    pushMatrix();
    //translate(location.x, location.y, location.z);
    ellipse(0, 0, 5, 5);
    popMatrix();
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
   
   rootPos = new PVector(width / 2, height, height /2); 
    
   PVector dir = new PVector(0, 10,0);
   root = new Branch(rootPos, rootPos, dir);
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
    PVector newLoc = new PVector(current.location.x + current.direction.x, current.location.y + current.direction.y, current.location.z + current.direction.z);
    Branch br = new Branch(newLoc, current.location, current.direction);
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
       Branch nBr = new Branch(newPos, br.location, br.direction);
       branches.add(nBr);
     }
     br.reset();
   }
  }
 
 
 void show(){
  if(pointsOn){
  for(int i = 0; i < leaves.length; i ++){
   leaves[i].display();
   }
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
 
 Branch(PVector cur, PVector las, PVector dir){
   location = cur.copy();
   ParentPos = las.copy();
   direction = dir.copy();
   originalDirection = direction.copy();
 }
 
 void reset(){
   direction = originalDirection.copy();
   count = 0;
 }
 
 void display(){
   strokeWeight(3);
   stroke(255, 150);
   line(ParentPos.x, ParentPos.y, location.x, location.y); 
 }
}

float log10(float x){
  return log(x) / log(10);
}