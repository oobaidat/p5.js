import java.text.DecimalFormat;
color colorStandard = color(165,42,42);
color colorStimulus = color(255,255,255);

int startTime;
int randomTime;

IntList reactionTimesList;

boolean stimulus = false;
boolean interval = false;
boolean earlyPress = false;
boolean startScreen = true;
boolean experimentScreen = false;
boolean resultScreen = false;



void setup() {
  size(800, 700);
}

void draw() {
  background(#E3BC9A);

  if (resultScreen) {
    
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
        return;
        
      }else {
        text("error : no results made", 100, 100);
          return;
      }
  }

  ellipseMode(CENTER);
  fill(colorStandard);
  rect(350, 300, 100, 100, 180);


  if (startScreen == true) {
      fill(0);
      textSize(20);
      text("PRESS THE SPACE BUTTON TO START", 220, 100);
      text("YOU HAVE TO TRY TO PRESS ON THE SPACE BUTTON WHEN \nTHE CIRCLE TURNS WHITE AS FAST AS YOU CAN", 150, 650);

      return;
  }else{
  
    fill(0);
    text("PRESS THE 'A' BUTTON TO QUIT", 280, 650);
    text("PRESS THE SPACE BUTTON WHEN THE CIRCLE IS WHITE", 180, 100);
  
    if (earlyPress == true) {
        text("TOO EARLY", 300, 540);
    }
  
    if (millis() > startTime + randomTime) {
          stimulus = true;
          earlyPress = false;
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


void keyPressed() {

  int SPACE_BUTTON = 32;
  
  if (key == SPACE_BUTTON && startScreen) {
      startScreen = false;
      experimentScreen = true;
      resultScreen = false;
      reactionTimesList = new IntList();

      startTime = millis();
      randomTime = (int) random(2000, 6000);
      
      return;
  }


  if (key == SPACE_BUTTON && experimentScreen && stimulus == false) {
      earlyPress = true;
      return;
  }


  if (key == SPACE_BUTTON && experimentScreen && stimulus) {
      int reactionTime = millis() - (startTime + randomTime);
      reactionTimesList.append(reactionTime);

      earlyPress = false;
      stimulus = false;
      
      startTime = millis();
      randomTime = (int) random(2000, 6000);
  
      return;
  }


  if (key == SPACE_BUTTON && resultScreen) {
    
      experimentScreen = false;
      startScreen = true;
      resultScreen = false;
      reactionTimesList = new IntList();

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
