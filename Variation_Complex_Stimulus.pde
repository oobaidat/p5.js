import java.util.Random;
import java.text.DecimalFormat;
color colorStandard = color(0,0,0);
String stringStimulus;

String trueStatement = "1 + 1 = 2";
String falseStatement = "11 + 11 = 23";
String randomString;

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
boolean trueStimulus = false;
boolean falseStimulus = false;



void setup() {
  size(800, 700);
  if (randomString() == trueStatement){
      stringStimulus = trueStatement;
      trueStimulus = true;
    }
    
    if (randomString() == falseStatement){
      stringStimulus = falseStatement;
      falseStimulus = true;
    }
}

void draw() {
  background(#E3BC9A);


  if (startScreen == true) {
      fill(0);
      textSize(20);
      text("PRESS THE SPACE BUTTON TO START", 420, 100);
      text("YOU HAVE TO \nPRESS 'T' WHEN THE EQUATION IS TRUE\nPRESS 'F' WHEN THE EQUATION IS FALSE", 350, 500);

      return;
  }else if (resultScreen) {
    
      background(#E3BC9A);
      fill(0);
      textSize(20);
      text("THE END", 100, 100);
      text("PRESS THE SPACE BUTTON TO RESTART THE EXPERIMENT", 400, 570);

      if (reactionTimesList.size() > 0) {
        
        int averageTimeMilis = reactionTimesList.sum() / reactionTimesList.size();
        float averageTimeSeconds = (float) ((float) averageTimeMilis / 1000.0);
        double reactionTimesSum = 0;
        
  
        for (int i = 0; i < reactionTimesList.size(); i++) {
          
            reactionTimesSum += Math.pow((reactionTimesList.get(i) - averageTimeMilis), 2);
        
         }
  
        double reactionTimes = reactionTimesSum / (reactionTimesList.size() - 1);
        float standard_deviation = (float) ((float) Math.sqrt(reactionTimes) / 1000.0);
        
        text("RESULT : ", 400, 300);
        text("THE AVERAGE REACTION TIME : " + averageTimeSeconds + " SECONDS", 400, 330);
        
        if (standard_deviation > 0) {
          DecimalFormat df = new DecimalFormat("#.####");
          
          text("THE STANDARD DEVIATION : " + df.format(standard_deviation) + " SECONDS", 400, 350);
  
        }else{
        
          text("THE STANDARD DEVIATION : YOU ONLY DID 1 ROUND,\nSO THERE IS NO STANDARD DEVIATION", 400, 350);
          
        }
        
        
       
        
      }else {
        text("error : no results made", 400, 100);
          return;
      }
      
      if (errorCounter > 0){
          text("COUNTED ERRORS : " + errorCounter + " ERRORS ", 400, 430);
        }else{
        
          text("NO ERRORS" , 400, 430);
          
        }
        
        if (earlyCounter > 0){
          text("COUNTED EARLY PRESSED KEYS : " + earlyCounter + " TIMES PRESSED KEYS EARLY", 400, 450);
        }else{
        
          text("NO EARLY PRESSED KEYS" , 400, 450);
          
        }
  }else{
  
    fill(0);
    text("PRESS THE 'A' BUTTON TO QUIT", 480, 650);
    text("PRESS 'T' WHEN TRUE\nPRESS 'F' WHEN FALSE", 480, 100);
    
   
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
          textAlign(CENTER);
          text(stringStimulus, 300, 250);
         
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

String randomString(){

    String random = new Random().nextBoolean() ? trueStatement : falseStatement;
    
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
  
  if (trueStimulus && stimulus && experimentScreen && key == 't'){
 
    int reactionTime = millis() - (startTime + randomTime);
      reactionTimesList.append(reactionTime);

      earlyPress = false;
      stimulus = false;
      otherKey = false;
      
      startTime = millis();
      randomTime = (int) random(2000, 6000);
      randomString = randomString();
      if (randomString == trueStatement){
      stringStimulus = trueStatement;
      trueStimulus = true;
      falseStimulus = false;
    }
    
    if (randomString() == falseStatement){
      stringStimulus = falseStatement;
      falseStimulus = true;
      trueStimulus = false;
    }
  
      return;
  
  }
  
  if (falseStimulus && stimulus && experimentScreen && key == 'f' && !trueStimulus){
 
    int reactionTime = millis() - (startTime + randomTime);
      reactionTimesList.append(reactionTime);

      earlyPress = false;
      otherKey = false;
      stimulus = false;
      
      startTime = millis();
      randomTime = (int) random(2000, 6000);
      
      randomString = randomString();
      if (randomString == trueStatement){
      stringStimulus = trueStatement;
      trueStimulus = true;
      falseStimulus = false;
    }
    
    if (randomString() == falseStatement){
      stringStimulus = falseStatement;
      falseStimulus = true;
      trueStimulus = false;
    }
  
      return;
  
  }
  
  if (experimentScreen && stimulus == false && key != 'a' && key != 'A') {
      earlyPress = true;
      earlyCounter+=1;
      return;
  }
  
  
  
  if (key != 't' && trueStimulus && key != 'a' && key != 'A' && experimentScreen){
      otherKey = true;
      errorCounter+=1;
      return;
  }

  if (key != 'f' && falseStimulus && key != 'a' && key != 'A' && experimentScreen){
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
