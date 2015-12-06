int level = 1;
int lives = 50;
int livesDist = 10;
int distanceToMissle = 0;
int distanceToShip = 0;
int numMissles = 0;
SpaceShip gideon;
Star [] manyStars;
ArrayList <Missle> manyMissles;
ArrayList <Asteroid> manyAsteroids;
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;
public void setup() 
{
  size(1200, 800);
  background(0);
  gideon = new SpaceShip();
  manyStars = new Star[100];
  manyAsteroids = new ArrayList <Asteroid>();
  manyMissles = new ArrayList <Missle>();
  for (int d=0; d<5; d++)
  {

    manyAsteroids.add(new Asteroid());
  }

  for (int i=0; i<manyStars.length; i++)
  {

    manyStars[i] = new Star();
  }
}
public void draw() 
{

  if (manyAsteroids.size()==0)
  {
    for (int d=0; d< (5+level); d++)
    {
      manyAsteroids.add(new Asteroid());
    }
    textSize(200);
    level +=1;
    text(level, width/2, height/2);
  }
  fill(0, 0, 0, 40);
  rect(0, 0, width, height);
  textSize(30);
  fill(255);
  text(level, width-50, 50);
  for (int l = 40; l < lives; l+=40)
  {
    noFill();
    stroke(255);
    ellipse(l, 30, 25, 25);
    l++;
  }
  //game over
  if (lives<=0)
  {
    textSize(50);
    textAlign(CENTER);
    fill(255);
    for (int g = 0; g < 1; g++)
    {
      text("GAME OVER. You reached level " + level, width/2, height/2);
       text("Refresh the page to try again, width/2, height/2+150);
      level = 0;
    }
  }
  gideon.show();
  gideon.move();

  for (int i=0; i<manyAsteroids.size (); i++) 
  {
    manyAsteroids.get(i).show();
    manyAsteroids.get(i).move();
  }
  for (int k=0; k<manyMissles.size (); k++) 
  {
    manyMissles.get(k).show();
    manyMissles.get(k).move();
  }
  //checks if missle hits an asteroid
  for (int z = 0; z < manyAsteroids.size (); z++)
  {
    for (int y = 0; y < manyMissles.size (); y++)
    {
      distanceToMissle
        = (int)(dist(manyMissles.get(y).getX(), manyMissles.get(y).getY(), 
      manyAsteroids.get(z).getX(), manyAsteroids.get(z).getY()));

      if (distanceToMissle <  manyAsteroids.get(z).getSize())
      {
        Asteroid old = manyAsteroids.get(z);
        if (old.getSize() > 20) //how big the original asteroid has to be to determine whether it will split or not
        {
          manyAsteroids.add(new Asteroid(old));
          manyAsteroids.add(new Asteroid(old));
        }
        manyMissles.remove(y);
        manyAsteroids.remove(z);
        numMissles--;
        break;
      }
    }
  }
  //
  //checks if the ship hits an asteroid
  for (int z = 0; z < manyAsteroids.size (); z++)
  {
    distanceToShip
      = (int)(dist(gideon.getX(), gideon.getY(), 
    manyAsteroids.get(z).getX(), manyAsteroids.get(z).getY()));

    if (distanceToShip <  manyAsteroids.get(z).getSize())
    {
      //asteroid will be destroyed, but won't split
      gideon.setX(width/2);
      gideon.setY(height/2); 
      gideon.setDirectionX(0); 
      gideon.setDirectionY(0); 
      gideon.setPointDirection(270); 
      lives -= 50;
      manyAsteroids.remove(z);
      break;
    }
  }
  //
  for (int g=0; g<manyStars.length; g++) 

  {
    manyStars[g].erase();
    manyStars[g].lookDown();
    manyStars[g].move();
    manyStars[g].wrap();
    manyStars[g].show();
  }

  for (int o = 0; o < manyMissles.size (); o++)
  {
    if (manyMissles.get(o).getX()> 1200 || manyMissles.get(o).getY()> 1200 || manyMissles.get(o).getX()<0 || manyMissles.get(o).getY()<0)
    {
      manyMissles.remove(o);
      numMissles--;
    }
  }

  if (leftPressed == true)
  {
    gideon.rotate(-5);
  }
  if (rightPressed == true)
  {
    gideon.rotate(5);
  }
  if (upPressed == true)
  {
    gideon.accelerate(0.56);
  }
  if (downPressed == true)
  {
    gideon.accelerate(-0.56);
  }
}
public void keyPressed()
{
  if (keyCode == LEFT)
  {
    leftPressed = true;
  }
  if (keyCode == RIGHT)
  {
    rightPressed = true;
  }
  if (keyCode == UP)
  {
    upPressed = true;
  }
  if (keyCode == DOWN)
  {
    downPressed = true;
  }
}
public void keyReleased()
{

  if (keyCode == LEFT)
  {
    leftPressed = false;
  }
  if (keyCode == RIGHT)
  {
    rightPressed = false;
  }
  if (keyCode == UP)
  {
    upPressed = false;
  }
  if (keyCode == DOWN)
  {
    downPressed = false;
  }

  if (key == 'h')
  {

    gideon.setX((int)(Math.random()*1200));
    gideon.setY((int)(Math.random()*800));
    // gideon.setDirectionX(2);
    // gideon.setDirectionY(2);
  }

  if (key == ' ')
  {
    //make a missle
    if (numMissles < 10+(level*2))
    {


      manyMissles.add(new Missle(gideon));
      numMissles++;
    }
  }
}

class Asteroid extends Floater

{
  private int rotSpeed;
  private int asteroidSize;

  Asteroid()
  {
    corners = 8;
    asteroidSize = 30;
    xCorners = new int[corners];
    yCorners = new int[corners];
    int z=0;
    for (double theta = 0; theta < Math.PI *2; theta = theta + Math.PI/4)
    {
      double r = Math.random()*asteroidSize+((int)(asteroidSize/3));
      xCorners[z] = (int)(r*Math.cos(theta));
      yCorners[z] = (int)(r*Math.sin(theta));
      z++;
    }
    rotSpeed = (int)(Math.random()*5)-2;
    myColor = color(255, 255, 255);   
    myCenterX = Math.random()*width;
    myCenterY = Math.random()*height; //holds center coordinates   
    myDirectionX = ((int)(Math.random()*20-10));
    myDirectionY = ((int)(Math.random()*20-10)); 
    if (myDirectionX < 3 || 0-myDirectionX <3)
    {
      myDirectionX = ((int)(Math.random()*20-10));
    }
    if (myDirectionY < 3 || 0-myDirectionY <3)
    {
      myDirectionY = ((int)(Math.random()*20-10));
    }
    //holds x and y coordinates of the vector for direction of travel   
    myPointDirection = Math.random()*360; //holds current direction the ship is pointing in degrees
  }

  public Asteroid(Asteroid old)
  {
    asteroidSize = (int)(old.getSize()/1.2);
    corners = 8;
    xCorners = new int[corners];
    yCorners = new int[corners];
    int z=0;
    for (double theta = 0; theta < Math.PI *2; theta = theta + Math.PI/4)
    {
      double r = Math.random()*asteroidSize+((int)(asteroidSize/3));
      ;
      xCorners[z] = (int)(r*Math.cos(theta));
      yCorners[z] = (int)(r*Math.sin(theta));
      z++;
    }
    rotSpeed = (int)(Math.random()*5)-2;
    myColor = color(255, 255, 255);   
    //
    myCenterX = old.getX();
    myCenterY = old.getY();
    //  
    myDirectionX = ((int)(Math.random()*20-10));
    myDirectionY = ((int)(Math.random()*20-10)); 
    if (myDirectionX < 3 || 0-myDirectionX <3)
    {
      myDirectionX = ((int)(Math.random()*20-10));
    }
    if (myDirectionY < 3 || 0-myDirectionY <3)
    {
      myDirectionY = ((int)(Math.random()*20-10));
    }
    //holds x and y coordinates of the vector for direction of travel   
    myPointDirection = Math.random()*360; //holds current direction the ship is pointing in degrees
  }
  public void setX(int x) {
    myCenterX = x;
  }  
  public int getX() {
    return (int)myCenterX;
  }
  public void setY(int y) {
    myCenterY = y;
  }
  public int getY() {
    return (int)myCenterY;
  } 
  public void setDirectionX(double x) {
    myDirectionX = x;
  }
  public double getDirectionX() {
    return myDirectionX;
  }
  public void setDirectionY(double y) {
    myDirectionY = y;
  }
  public double getDirectionY() {
    return myDirectionY;
  }
  public void setPointDirection(int degrees) {
    myPointDirection = degrees;
  }  
  public double getPointDirection() {
    return myPointDirection;
  } 

  public void setSize(int x) {
    asteroidSize = x;
  }  
  public int getSize() {
    return asteroidSize;
  }

  void move()
  { 
    rotate(rotSpeed);
    super.move();
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
    myColor = color((int)(Math.random()*256), (int)(Math.random()*256), (int)(Math.random()*256));   
    myCenterX = width/2;
    myCenterY = height/2; //holds center coordinates   
    myDirectionX = 0;
    myDirectionY = 0; //holds x and y coordinates of the vector for direction of travel   
    myPointDirection = 270; //holds current direction the ship is pointing in degrees
  }
  public void setX(int x) {
    myCenterX = x;
  }  
  public int getX() {
    return (int)myCenterX;
  }
  public void setY(int y) {
    myCenterY = y;
  }
  public int getY() {
    return (int)myCenterY;
  } 
  public void setDirectionX(double x) {
    myDirectionX = x;
  }
  public double getDirectionX() {
    return myDirectionX;
  }
  public void setDirectionY(double y) {
    myDirectionY = y;
  }
  public double getDirectionY() {
    return myDirectionY;
  }
  public void setPointDirection(int degrees) {
    myPointDirection = degrees;
  }  
  public double getPointDirection() {
    return myPointDirection;
  } 
  // return null;
}

class Missle extends Floater
{
  Missle(SpaceShip gideon)
  {
    myCenterX = gideon.getX();
    myCenterY = gideon.getY();
    myPointDirection = gideon.getPointDirection();
    double dRadians = myPointDirection*(Math.PI/180);
    myDirectionX = 5 * Math.cos(dRadians) + gideon.getDirectionX();
    myDirectionY = 5 * Math.sin(dRadians) + gideon.getDirectionY();
    myColor = color((int)(Math.random()*256), (int)(Math.random()*256), (int)(Math.random()*256));
  }
  public void setX(int x) {
    myCenterX = x;
  }  
  public int getX() {
    return (int)myCenterX;
  }
  public void setY(int y) {
    myCenterY = y;
  }
  public int getY() {
    return (int)myCenterY;
  } 
  public void setDirectionX(double x) {
    myDirectionX = x;
  }
  public double getDirectionX() {
    return myDirectionX;
  }
  public void setDirectionY(double y) {
    myDirectionY = y;
  }
  public double getDirectionY() {
    return myDirectionY;
  }
  public void setPointDirection(int degrees) {
    myPointDirection = degrees;
  }  
  public double getPointDirection() {
    return myPointDirection;
  } 

  void show()
  {
    fill(myColor);
    stroke(myColor);
    ellipse((int)(myCenterX), (int)(myCenterY), 5, 5);
  }
  void move()
  {
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;
  }
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
    if (myCenterX > width)
    {     
      myCenterX = 0;
    } else if (myCenterX < 0)
    {     
      myCenterX = width;
    }    
    if (myCenterY > height)
    {    
      myCenterY = 0;
    } else if (myCenterY < 0)
    {     
      myCenterY = height;
    }
  }   
  public void show ()  //Draws the floater at the current position  
  {             
    fill(myColor); 
    noFill();  
    stroke(myColor);    
    //convert degrees to radians for sin and cos         
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for (int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]* Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]* Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated, yRotatedTranslated);
    }   
    endShape(CLOSE);
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
    } else if (sparkleX == 2)
    {
      sparkleY = 4;
    } else if (sparkleX == 4)
    {
      sparkleY = 2;
    } else 
    {
      sparkleY = 1;
    }
  }
  void show()
  {

    noStroke();
    int randColor = (int)(Math.random()*155+100);
    if (get(myX, myY+sparkleY)!=color(205))
    {
      fill(randColor, randColor, randColor);
    } else
    {
      fill(0);
    }
    ellipse(myX, myY, sparkleX, sparkleY);
    ellipse(myX, myY, sparkleY, sparkleX);
  }
  void lookDown()
  {
    isMoving = true;
    sparkleX = sparkleX + (int)(Math.random()*8-4);
    sparkleY = sparkleY + (int)(Math.random()*8-4);
    if (sparkleX == sparkleY)
    {
      if (Math.random()>0.5)
      {
        sparkleX = 4;
        sparkleY = 1;
      } else 
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
  void erase()
  {
    fill(0);
    stroke(0);
    ellipse(myX, myY, sparkleX+(sparkleX/2), sparkleY+(sparkleY/2));
  }
  void move()
  {
    if (isMoving)
    {
      myX -= gideon.getDirectionX();
      myY -= gideon.getDirectionY();
    }
    // void move() which checks if the snow flake isMoving. If it is, increase y by one
  }
  void wrap()
  {
    if (myY >= height)
    {
      myX = (int)(Math.random()*1200);
      myY = (int)(Math.random()*200);
    }
    if (myX >= width)
    {
      myX = (int)(Math.random()*200);
      myY = (int)(Math.random()*800);
    }
    if (myY <= 0)
    {
      myX = (int)(Math.random()*1200);
      myY = (int)(Math.random()*200+600);
    }
    if (myX <= 0)
    {
      myX = (int)(Math.random()*200+1000);
      myY = (int)(Math.random()*800);
    }

    // void wrap() which checks if the y coordinate is off the bottom of the screen. 
    //If it is, set y to 0 and generate a new random x coordinate
  }
}
