import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class AsteroidsGame extends PApplet {

SpaceShip gideon;
Star [] kawaii;
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;
public void setup() 
{
size(1200, 800);
background(0);
gideon = new SpaceShip();
kawaii = new Star[100];



  for (int i=0; i<kawaii.length; i++)
  {

    kawaii[i] = new Star();
  }
}
public void draw() 
{
  fill(0,0,0,50);
  rect(0,0,width,height);
// background(0);
gideon.show();
gideon.move();
gideon.hyperspace();
for (int g=0; g<kawaii.length; g++) 

  {
    kawaii[g].erase();
    kawaii[g].lookDown();
    kawaii[g].move();
    kawaii[g].wrap();
    kawaii[g].show();
  }
if(leftPressed == true)
{
  gideon.rotate(-5);
}
if(rightPressed == true)
{
  gideon.rotate(5);
}
if(upPressed == true)
{
  gideon.accelerate(0.11f);
}
if(downPressed == true)
{
  gideon.accelerate(-0.11f);
}
}
 public void keyPressed()
{
if(keyCode == LEFT)
{
  leftPressed = true;
}
if(keyCode == RIGHT)
{
rightPressed = true;
}
if(keyCode == UP)
{
upPressed = true;
}
if(keyCode == DOWN)
{
downPressed = true;
}
}
public void keyReleased()
{
  if (key == ' ')
    {
  
  gideon.setX((int)(Math.random()*1200));
  gideon.setY((int)(Math.random()*800));
  gideon.setDirectionX(0);
  gideon.setDirectionY(0);
}
if(keyCode == LEFT)
{
  leftPressed = false;
}
if(keyCode == RIGHT)
{
rightPressed = false;
}
if(keyCode == UP)
{
upPressed = false;
}
if(keyCode == DOWN)
{
downPressed = false;
}
}
class SpaceShip extends Floater 
{   
SpaceShip()
{
    corners = 4;
    xCorners = new int[corners]; 
    yCorners = new int[corners]; 
    xCorners[0] = -8;
    yCorners[0] = -8;
    xCorners[1] = 16;
    yCorners[1] = 0;
    xCorners[2] = -8;
    yCorners[2] = 8;
    xCorners[3] = -2;
    yCorners[3] = 0;
    myColor = color(255,255,255);   
    myCenterX = width/2;
     myCenterY = height/2; //holds center coordinates   
    myDirectionX = 0;
     myDirectionY = 0; //holds x and y coordinates of the vector for direction of travel   
    myPointDirection = 270; //holds current direction the ship is pointing in degrees    
}
public void setX(int x){myCenterX = x;}  
public int getX() {return (int)myCenterX;}
public void setY(int y){myCenterY = y;}
public int getY(){return (int)myCenterY;} 
public void setDirectionX(double x){myDirectionX = x;}
public double getDirectionX() {return myDirectionX;}
public void setDirectionY(double y){myDirectionY = y;}
public double getDirectionY() {return myDirectionY;}
public void setPointDirection(int degrees){myPointDirection = degrees;}  
 public double getPointDirection(){return myPointDirection;} 
  // return null;



}




abstract class Floater //Do NOT modify the Floater class! Make changes in the SpaceShip class 
{   
  protected int corners;  //the number of corners, a triangular floater has 3   
  protected int[] xCorners;   
  protected int[] yCorners;   
  protected int myColor;   
  protected double myCenterX, myCenterY; //holds center coordinates   
  protected double myDirectionX, myDirectionY; //holds x and y coordinates of the vector for direction of travel   
  protected double myPointDirection; //holds current direction the ship is pointing in degrees    
  abstract public void setX(int x);  
  abstract public int getX();   
  abstract public void setY(int y);   
  abstract public int getY();   
  abstract public void setDirectionX(double x);   
  abstract public double getDirectionX();   
  abstract public void setDirectionY(double y);   
  abstract public double getDirectionY();   
  abstract public void setPointDirection(int degrees);   
  abstract public double getPointDirection(); 

  //Accelerates the floater in the direction it is pointing (myPointDirection)   
  public void accelerate (double dAmount)   
  {          
    //convert the current direction the floater is pointing to radians    
    double dRadians =myPointDirection*(Math.PI/180);     
    //change coordinates of direction of travel    
    myDirectionX += ((dAmount) * Math.cos(dRadians));    
    myDirectionY += ((dAmount) * Math.sin(dRadians));       
  }   
  public void rotate (int nDegreesOfRotation)   
  {     
    //rotates the floater by a given number of degrees    
    myPointDirection+=nDegreesOfRotation;   
  }   
  public void move ()   //move the floater in the current direction of travel
  {      
    //change the x and y coordinates by myDirectionX and myDirectionY       
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;     

    //wrap around screen    
    if(myCenterX > width)
    {     
      myCenterX = 0;    
    }    
    else if (myCenterX < 0)
    {     
      myCenterX = width;    
    }    
    if(myCenterY > height)
    {    
      myCenterY = 0;    
    }   
    else if (myCenterY < 0)
    {     
      myCenterY = height;    
    }   
  }   
  public void show ()  //Draws the floater at the current position  
  {             
    fill(myColor);   
    stroke(myColor);    
    //convert degrees to radians for sin and cos         
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for(int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]* Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]* Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated,yRotatedTranslated);    
    }   
    endShape(CLOSE);  
  }   
public void hyperspace()
{
  // if(keyReleased == true)
  // {
    
// }
}
}

class Star    
{     
  int myX;
  int myY;
  int mySize;
  int sparkleX;
  int sparkleY;
  boolean isMoving = true;
  Star()
  {
    myX = (int)(Math.random()*width);
    myY = (int)(Math.random()*height);
    mySize = 2;
    sparkleX = (int)(Math.random()*5);
    //    sparkleY = (int)(Math.random()*5);
    if (sparkleX == 3)
    {
      sparkleX = (int)(Math.random()*5);
    }
    if (sparkleX == 1)
    {
      sparkleY = 5;
    }
    else if (sparkleX == 2)
    {
      sparkleY = 4;
    }
    else if (sparkleX == 4)
    {
      sparkleY = 2;
    }
    else 
    {
      sparkleY = 1;
    }
  }
  public void show()
  {

    noStroke();
    int randColor = (int)(Math.random()*155+100);
    if (get(myX, myY+sparkleY)!=color(205))
    {
      fill(randColor, randColor, randColor);
    }
    else
    {
      fill(0);
    }
    ellipse(myX, myY, sparkleX, sparkleY);
    ellipse(myX, myY, sparkleY, sparkleX);
  }
  public void lookDown()
  {
      isMoving = true;
      sparkleX = sparkleX + (int)(Math.random()*8-4);
      sparkleY = sparkleY + (int)(Math.random()*8-4);
      if (sparkleX == sparkleY)
      {
        if (Math.random()>0.5f)
        {
          sparkleX = 4;
          sparkleY = 1;
        }
        else 
        {
          sparkleX = 1;
          sparkleY = 4;
        }
      }
      if (sparkleX > 5)
      {
        sparkleY = 1;
        sparkleX = 5;
      }
      if (sparkleX < 1)
      {
        sparkleX = 1;
      }
      if (sparkleY > 5)
      {
        sparkleX = 1;
        sparkleY = 5;
      }
      if (sparkleY < 1)
      {
        sparkleY = 1;
      }
    // }
    // void lookDown() checks if y is between the top and bottom of the screen, and the position just below (x,y) is not black. 
    //If so, set isMoving to false; otherwise set isMoving to true
  }
  public void erase()
  {
    fill(0);
    stroke(0);
    ellipse(myX, myY, sparkleX+(sparkleX/2), sparkleY+(sparkleY/2));
  }
  public void move()
  {
    if (isMoving)
    {
      myX -= gideon.getDirectionX();
      myY -= gideon.getDirectionY();
    }
    // void move() which checks if the snow flake isMoving. If it is, increase y by one
  }
  public void wrap()
  {
    if (myY > height)
    {
      myX = (int)(Math.random()*1200);
      myY = (int)(Math.random()*200);
    }
    if (myX > width)
    {
      myX = (int)(Math.random()*200);
      myY = (int)(Math.random()*800);
    }
   if (myY < 0)
    {
      myX = (int)(Math.random()*1200);
      myY = (int)(Math.random()*200+600);
    }
    if (myX < 0)
    {
      myX = (int)(Math.random()*200+1000);
      myY = (int)(Math.random()*800);
    }
     
    // void wrap() which checks if the y coordinate is off the bottom of the screen. 
    //If it is, set y to 0 and generate a new random x coordinate
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "AsteroidsGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
