import java.util.Random;
import java.text.DecimalFormat;
color colorStandard = color(0,0,0);
color colorStimulus;
color red = color(255,0,0);
color blue = color(0,0,255);

int startTime;
int randomTime;
int errorCounter;
int earlyCounter;

IntList reactionTimesList;

boolean stimulus = false;
boolean interval = false;
boolean earlyPress = false;
boolean startScreen = true;
boolean experimentScreen = false;
boolean resultScreen = false;
boolean otherKey = false;
boolean redStimulus = false;
boolean blueStimulus = false;



void setup() {
  size(800, 700);
  if (randomColor() == red){
      colorStimulus = red;
      redStimulus = true;
    }
    
    if (randomColor() == blue){
      colorStimulus = blue;
      blueStimulus = true;
    }
}

void draw() {
  background(#E3BC9A);

  

  ellipseMode(CENTER);
  fill(colorStandard);
  rect(350, 300, 100, 100, 180);


  if (startScreen == true) {
      fill(0);
      textSize(20);
      text("PRESS THE SPACE BUTTON TO START", 220, 100);
      text("YOU HAVE TO \nPRESS 'R' WHEN THE CIRCLE IS RED\nPRESS 'B' WHEN THE CIRCLE IS BLUE", 150, 500);

      return;
  }else if (resultScreen) {
    
      background(#E3BC9A);
      fill(0);
      textSize(20);
      text("THE END", 100, 40);
      text("PRESS THE SPACE BUTTON TO RESTART THE EXPERIMENT", 100, 570);

      if (reactionTimesList.size() > 0) {
        
        int averageTimeMilis = reactionTimesList.sum() / reactionTimesList.size();
        float averageTimeSeconds = (float) ((float) averageTimeMilis / 1000.0);
        double reactionTimesSum = 0;
        
  
        for (int i = 0; i < reactionTimesList.size(); i++) {
          
            reactionTimesSum += Math.pow((reactionTimesList.get(i) - averageTimeMilis), 2);
        
         }
  
        double reactionTimes = reactionTimesSum / (reactionTimesList.size() - 1);
        float standard_deviation = (float) ((float) Math.sqrt(reactionTimes) / 1000.0);
        
        text("RESULT : ", 100, 300);
        text("THE AVERAGE REACTION TIME : " + averageTimeSeconds + " SECONDS", 100, 330);
        
        if (standard_deviation > 0) {
          DecimalFormat df = new DecimalFormat("#.####");
          
          text("THE STANDARD DEVIATION : " + df.format(standard_deviation) + " SECONDS", 100, 350);
  
        }else{
        
          text("THE STANDARD DEVIATION : YOU ONLY DID 1 ROUND,\nSO THERE IS NO STANDARD DEVIATION", 100, 350);
          
        }
        
        
       
        
      }else {
        text("error : no results made", 100, 100);
          return;
      }
      
      if (errorCounter > 0){
          text("COUNTED ERRORS : " + errorCounter + " ERRORS ", 100, 430);
        }else{
        
          text("NO ERRORS" , 100, 430);
          
        }
        
        if (earlyCounter > 0){
          text("COUNTED EARLY PRESSED KEYS : " + earlyCounter + " TIMES PRESSED KEYS EARLY", 100, 450);
        }else{
        
          text("NO EARLY PRESSED KEYS" , 100, 450);
          
        }
  }else{
  
    fill(0);
    text("PRESS THE 'A' BUTTON TO QUIT", 280, 650);
    text("PRESS 'R' WHEN RED\nPRESS 'B' WHEN BLUE", 180, 100);
    
   
    if (earlyPress == true) {
        text("TOO EARLY", 300, 540);
    }
    
    if (otherKey == true) {
        text("WRONG KEY", 300, 560);
    }
    
    
    
  
    if (millis() > startTime + randomTime) {
     
     
          stimulus = true;
          earlyPress = false;
          otherKey = false;
          ellipseMode(CENTER);
          fill(colorStimulus);
          rect(350, 300, 100, 100, 180);
         
    }
  
    if (reactionTimesList.size() < 0) {
        return;
        
    }else if (reactionTimesList.size() > 0) {
      
        int recentReactionTime = reactionTimesList.get(reactionTimesList.size() - 1);
        float seconds = (float) recentReactionTime / 1000.0;
        fill(0);
        text("REACTION TIME : " + seconds + " seconds", 260, 200);
        
   }
  }
}

color randomColor(){

    color random = new Random().nextBoolean() ? red : blue;
    
    return random;
}


void keyPressed() {

  
  int SPACE_BUTTON = 32;
  
  
  if (key == SPACE_BUTTON && startScreen) {
      startScreen = false;
      experimentScreen = true;
      resultScreen = false;
      reactionTimesList = new IntList();
      reactionTimesList = new IntList();

   
      startTime = millis();
      randomTime = (int) random(2000, 6000);
      
      return;
  }
  
  if (redStimulus && stimulus && experimentScreen && key == 'r'){
 
    int reactionTime = millis() - (startTime + randomTime);
      reactionTimesList.append(reactionTime);

      earlyPress = false;
      stimulus = false;
      otherKey = false;
      
      startTime = millis();
      randomTime = (int) random(2000, 6000);
      
      if (randomColor() == red){
      colorStimulus = red;
      redStimulus = true;
    }
    
    if (randomColor() == blue){
      colorStimulus = blue;
      blueStimulus = true;
    }
  
      return;
  
  }
  
  if (blueStimulus == true && stimulus && experimentScreen && key == 'b'){
 
    int reactionTime = millis() - (startTime + randomTime);
      reactionTimesList.append(reactionTime);

      earlyPress = false;
      otherKey = false;
      stimulus = false;
      
      startTime = millis();
      randomTime = (int) random(2000, 6000);
      
      if (randomColor() == red){
      colorStimulus = red;
      redStimulus = true;
    }
    
    if (randomColor() == blue){
      colorStimulus = blue;
      blueStimulus = true;
    }
  
      return;
  
  }
  
  if (experimentScreen && stimulus == false && key != 'a' && key != 'A') {
      earlyPress = true;
      earlyCounter+=1;
      return;
  }
  
  
  
  if (key != 'r' && redStimulus && key != 'a' && key != 'A' && experimentScreen){
      otherKey = true;
      errorCounter+=1;
      return;
  }

  if (key != 'r' && blueStimulus && key != 'a' && key != 'A' && experimentScreen){
      otherKey = true;
      errorCounter+=1;
      return;
  }
   

  if (key == SPACE_BUTTON && resultScreen) {
    
      experimentScreen = false;
      startScreen = true;
      resultScreen = false;
      reactionTimesList = new IntList();
      errorCounter = 0;
      
      startTime = millis();
      randomTime = (int) random(2000, 6000);
  
      return;
  }



  if (key == 'a' && experimentScreen) {

      experimentScreen = false;
      startScreen = false;
      resultScreen = true;
      return;
      
  }
  
  if (key == 'A' && experimentScreen) {

      experimentScreen = false;
      startScreen = false;
      resultScreen = true;
      return;
  }
  

    
    
    
}
