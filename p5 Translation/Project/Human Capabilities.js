//letiables for colors
let colorStandard;
let colorStimulus;

//letiables for time
let startTime;
let randomTime;

//reaction time array
let reactionTimesList;

//boolean values to display what screen
let stimulus = false;
let interval = false;
let earlyPress = false;
let startScreen = true;
let experimentScreen = false;
let resultScreen = false;

//creates canvas and defines the colors
function setup() {
	createCanvas(800, 700);
	colorStandard = color(165,42,42);
	colorStimulus = color(255,255,255);
}

//the experiment
function draw() {
	background(227, 188, 154);

	//draws circle in centre which changes color for reaction
	ellipseMode(CENTER);
	fill(colorStandard);
	rect(350, 300, 100, 100, 180);

	//if it's the start screen, explain the experiment to the user
	if (startScreen) {

		fill(0);
		textSize(20);
		text("PRESS THE SPACE BUTTON TO START", 220, 100);
		text("YOU HAVE TO TRY TO PRESS ON THE SPACE BUTTON WHEN \nTHE CIRCLE TURNS WHITE AS FAST AS YOU CAN", 150, 650);
		return;
	}

	//tells the user what to do when the experiment starts
	if (experimentScreen) {

		fill(0);
		text("PRESS THE 'A' BUTTON TO QUIT", 280, 650);
		text("PRESS THE SPACE BUTTON WHEN THE CIRCLE IS WHITE", 180, 100);
		
		//tells the user if they raected too early, and resets the timers (see below)
		if (earlyPress) {
			text("TOO EARLY", 300, 540);
		}

		//changes the color of the circle according to when the user (started the experiment + the random time) to the time of the experiment
		if (millis() > startTime + randomTime) {
			stimulus = true;
			earlyPress = false;
			ellipseMode(CENTER);
			fill(colorStimulus);
			rect(350, 300, 100, 100, 180);
		}

		//displays the user's reaction time if they did
		if (reactionTimesList.length > 0) {
			let recentReactionTime = reactionTimesList[reactionTimesList.length - 1];
			let seconds = recentReactionTime / 1000.0;
			fill(0);
			text("REACTION TIME : " + round(seconds, 3) + " seconds", 260, 200);
		}
		return;
	}

	//resets the screen and shows the user their results and tells them if they want to restart the experiment
	if (resultScreen) {
		clear();
		background(227, 188, 154);

		fill(0);
		textSize(20);
		text("THE END", 100, 40);
		text("PRESS THE SPACE BUTTON TO RESTART THE EXPERIMENT", 100, 570);

		//shows the user their avg reaction time
		if (reactionTimesList.length > 0) {
			let reactionTimesSum = 0;
			for (let i = 0; i < reactionTimesList.length; i++) {
				reactionTimesSum += reactionTimesList[i];
			}

			let averageTimeMilis = reactionTimesSum / reactionTimesList.length;
			let averageTimeSeconds = averageTimeMilis / 1000.0;

			let avgSum = 0;
			for (let i = 0; i < reactionTimesList.length; i++) {
				avgSum += Math.pow((reactionTimesList[i] - averageTimeMilis), 2);
			}

			let reactionTimes = avgSum / reactionTimesList.length;
			let standard_deviation = Math.sqrt(reactionTimes) / 1000.0;

			text("RESULT : ", 100, 300);
			text("THE AVERAGE REACTION TIME : " + round(averageTimeSeconds, 3) + " SECONDS", 100, 330);

			//if they reacted more than once shows them their standard deviation
			if (standard_deviation > 0) {
				text("THE STANDARD DEVIATION : " + round(standard_deviation, 3) + " SECONDS", 100, 350);

			} else {
				text("THE STANDARD DEVIATION : YOU ONLY DID 1 ROUND,\nSO THERE IS NO STANDARD DEVIATION", 100, 350);     
			}
			return;

		//tells them if they never reacted	
		} else {
			text("error : no results made", 100, 100);
			return;
		}
	}
}


//function that changes the booleans to show different screens
function keyPressed() {

	//changes to the experiment screen if space is pressed in the start screen, assigns the time values for the experiment, and creates the reaction array
	if (keyCode == 32 && startScreen) {
		startScreen = false;
		experimentScreen = true;
		resultScreen = false;
		reactionTimesList = new Array(0);

		startTime = millis();
		randomTime = random(2000, 6000);

		return;
	}

	//restarts the timers for the experiment if the user reacted too early
	if (keyCode == 32 && experimentScreen && stimulus == false) {
		earlyPress = true;

		startTime = millis();
		randomTime = random(2000, 6000);
		return;
	}

	//stores the reaction time of the user when they react using space in the reaction array, resets the earlyPress boolean and restarts the experiment
	if (keyCode == 32 && experimentScreen && stimulus) {
		let reactionTime = millis() - (startTime + randomTime);
		append(reactionTimesList, reactionTime);

		earlyPress = false;
		stimulus = false;

		startTime = millis();
		randomTime = random(2000, 6000);

		return;
	}

	//restarts the experiment if the user presses space in the result screen, recreating the reaction array and making sure the earlyPress boolean is false again
	if (keyCode == 32 && resultScreen) {

		experimentScreen = true;
		startScreen = false;
		resultScreen = false;
		earlyPress = false;
		reactionTimesList = new Array();

		startTime = millis();
		randomTime = random(2000, 6000);

		return;
	}

	//stops the experiment if the user presses 'a'/'A' and displays the user's results
	if (keyCode == 65 && experimentScreen) {

		experimentScreen = false;
		startScreen = false;
		resultScreen = true;
		return;
	}

}