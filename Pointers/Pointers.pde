import java.util.Random;
import java.text.DecimalFormat;

//variables for rectangle
color c;
float xplace;
float yplace;

//reaction time arrays
FloatList invertedTimesList = new FloatList();
FloatList weirdTimesList = new FloatList();
FloatList fastTimesList = new FloatList();

//variables for time
float startTime;
float randomTime;
float invertedTime;
float weirdTime;
float fastTime;

//creates a decimal format to make things clearer
DecimalFormat df = new DecimalFormat("#.###");

//boolean variables
boolean start = false;
boolean stimulus = false;
boolean inverted = false;
boolean weird = false;
boolean fast = false;

//creates window
void setup() {
  size(900, 900);
}

//the experiment
void draw() {
  background(126);

  //starts by telling the user what to do
  fill(0);
  textSize(20);
  text("Press: '1' for inverted, '2' for weird mouse, '3' for fast mouse", 150, 100);
  text("A square will appear randomly in the middle\n click on it with the drawn pointer", 230, 700);

  //experiment starts when the user presses '1'/'2'/'3'
  if (start) {
    fillScreen();
    noCursor();

    //makes the rectangle appear according to when the user started the experiment + some random time
    if (millis() >= startTime + randomTime) {
      //changes color of rectangle and tells the user what to do next after clicking the rectangle
      if (!stimulus) {
        c = color(255);
      } else {
        c = color(0, 255, 0);

        fill(0);
        textSize(20);
        text("To go again press: '1' for inverted, '2' for weird mouse, '3' for fast mouse", 110, 700);
      }
      fill(c);
      rect(xplace, yplace, 100, 80);
    }

    //makes pointer, registers click of pointer on the rectangle and adds reaction time to to array
    if (inverted) {
      fill(255, 0, 255);
      ellipse(mouseY, mouseX, 33, 33);
      if (mousePressed == true) {
        if ((mouseY >= xplace) && (mouseY <= xplace+100) && (mouseX >= yplace) && (mouseX <= yplace+80)) {
          //to make it that the time won't be added to the array everytime the user clicks
          if (!stimulus) {
            invertedTimesList.append(millis() - (startTime + randomTime));
            invertedTime = invertedTimesList.sum() / invertedTimesList.size()/1000.0;
          }
          stimulus = true;
        }
      }
    } else if (weird) {
      fill(255, 0, 255);
      ellipse((float)Math.pow(mouseX-250,4)/3000000,mouseY/1.35, 33, 33);
      if (mousePressed == true) {
        if (((float)Math.pow(mouseX-250,4)/3000000 >= xplace) && ((float)Math.pow(mouseX-250,4)/3000000 <= xplace+100) 
        && (mouseY/1.35 >= yplace) && (mouseY/1.35 <= yplace+80)) {
          if (!stimulus) {
            weirdTimesList.append(millis() - (startTime + randomTime));
            weirdTime = weirdTimesList.sum() / weirdTimesList.size()/1000.0;
          }
          stimulus = true;
        }
      }
    } else if (fast) {
      fill(255, 0, 255);
      ellipse(mouseX*2, mouseY*2, 33, 33); 
      if (mousePressed == true) {
        if ((mouseX*2 >= xplace) && (mouseX*2 <= xplace+100) && (mouseY*2 >= yplace) && (mouseY*2 <= yplace+80)) {
          if (!stimulus) {
            fastTimesList.append(millis() - (startTime + randomTime));
            fastTime = fastTimesList.sum() / fastTimesList.size()/1000.0;
          }
          stimulus = true;
        }
      }
    }
  }
}

//writes everything needed on the screen
void fillScreen() {
  clear();
  background(126);

  fill(0);
  text("Click on the rectangle with the pointer", 250, 100);
  text("Avg reaction inverted: " + df.format(invertedTime) + "\nAvg reaction weird: " + df.format(weirdTime) + 
    "\nAvg reaction fast: " + df.format(fastTime), 250, 750);
}

//changes pointer depending on what is pressed and assigns new time values and rectangle placement
void keyPressed() {
  //makes the inverted pointer
  if (key == '1') {
    start = true;
    stimulus = false;

    inverted = true;
    weird = false;
    fast = false;

    startTime = millis();
    randomTime = random(2000.0, 6000.0);

    xplace = random(150, 650);
    yplace = random(200, 500);
  }

  //makes the slow pointer
  if (key == '2') {
    start = true;
    stimulus = false;

    inverted = false;
    weird = true;
    fast = false;

    startTime = millis();
    randomTime = random(2000.0, 6000.0);

    xplace = random(150, 650);
    yplace = random(200, 500);
  }

  //makes the fast pointer
  if (key == '3') {
    start = true;
    stimulus = false;

    inverted = false;
    weird = false;
    fast = true;

    startTime = millis();
    randomTime = random(2000.0, 6000.0);

    xplace = random(150, 650);
    yplace = random(200, 500);
  }
}
