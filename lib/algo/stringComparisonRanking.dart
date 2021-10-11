import 'dart:core';

import 'dart:math';

String getQuote(String title, String description) {
  //return value
  String quote = '';

  //**List of Keywords */
  List<String> keyWords = [
    //daily task
    'Home House Room Kitchen Garden Household Chores Clean Cook Grocery Market Shop Food Duty Housework Walk Eat Feed Care Errand Sleep Laundry Dust Sweep Trash Vacuum Lawn Car Pets Garage Dishes Clothing Closet Routine Pattern Habit Birthday Wipe Recycle Mop Refrigerator Cabinets Furniture Mattress Duvet Pillow Windows Dishwasher Shower Bath Meditate Nap Brush Dressed Arrive Asleep Dinner Lunch Breakfast Tidy Drive Makeup Wash Hang Iron Plant Clutter Fold Sanitize Boil Budget Money',
    //schoold Task
    'Schoolwork Activity Assignment Review Test Exam Training Tutorial Essay Quiz Recap Study Memorize Familiarize Learn Think Homework Exercises Project Lesson Thesis Article Paperwork Submit Pass Create Search Research Document Upload Download Write Read Master School University Draw Score Grades Mark Compute Tackle Understand Notebook Academic Competition Event Portfolio Practicum Presentation Group Coursework English Science Math Handwriting Speech Debate Algebra Geometry Geography Physics Chemistry Biology Economics Literature Poetry Poem Recitation Vocabulary Grammar Botany Astronomy Ecology Meteorology Calculus Accounting Statistics Trigonometry History Psychology Sociology Anthropology Genealogy Philosophy Logic Programming Computers Arts Google MS Word Excel PDF Edit Library',
    //Entertainement
    'Facebook Youtube Twitter Instagram Play Messenger Chat Jamming Sing Music Paint Dance Fun Games Enjoy Shopping Mall Chat Message Friends Family Relatives Leisure Travel Trip Beach Swim TV Movie Watch Park Circus Carnival Books Concerts Festival Fairs Shows Museums K-drama Netflix Picnic Party Bake Vacation Staycation Hotel Playground Restaurant Camping Buy Anime Cartoons',
    //mental health
    'Stress Anxiety Depression Sad Happy Free Therapy Hate Poor Ill Disorder Paranoid Suffer Mood Emotion Mad Angry Doctor Therapist Socialize Sweetheart Trauma Memory Incapable Psychological Spiritual Suffer Abuse Heal Neglect Insanity Crazy Afraid Scared Troubled Unbalanced Mental Disturbed Derangement Sick Phobia Compulsive Obsession Difficulties Optimist Issues Problems Pessimist Hardships Negative Positive Hinder Suicide Neglect Energy Concentrate Distress Wellness Alone Lonely Addiction Grief Hate Lack Failure Chronic Crisis Offend Burnout',
    //physichal health
    'Sports Basketball Volleyball Football Soccer Badminton Tennis Migraine Exercise Drink Sleep Detox Diet Healthy Jog Gym Run Walk Vegetables Fruits Fit Cardio Weights Body Thin Overweight Shape Muscles Abs Meditate Yoga Hygiene Bicycle Hiking Biking Swimming Aerobic Jump Workout Athlete Calories Fats Portion Intake Track Squats Pushup Lunges Burpees Rope Twists Bodyweight Hydrated Cardio Carbs Fiber Protein',
    //career
    'Job Hunting Interview Career Profession Occupation Work Field Business Calling Line Internship Graduate Vocation Course Future Employment Pursuit Path Craft Missions Service Posting Office Company Position Degree Accountancy Engineering Teacher Marketing Advertising Programmer Hiring Industry Entrepreneurship Administration Managers Nursing Bachelor Masters Doctorate Strengths Weaknesses Journey Interests Passion Resume Part-time Entry-level',
  ];

  //**List of Quotes */
  List<String> dailyTask = [
    '"Your future is found in your daily routine. Successful people do daily what others do occasionally" \n-Paula White',
    '"Many of life’s failures are people who did not realize how close they were to success when they gave up" \n-Thomas A. Edison',
    '"Think in the morning. Act in the noon. Eat in the evening. Sleep in the night" \n-William Blake',
    '"Get busy living or get busy dying." \n-Stephen King',
    '"Money and success don’t change people; they merely amplify what is already there." \n-Will Smith',
    '"Smile in the mirror. Do that every morning and you’ll start to see a big difference in your life" \n-Yoko Ono',
    '"Your time is limited, so don’t waste it living someone else’s life. Don’t be trapped by dogma – which is living with the results of other people’s thinking." \n-Steve Jobs',
    '"Your future is created by what you do today, not tomorrow" \n-Robert Kiyosaki',
    '"Every morning starts a new page in your story. Make it a great one today" \n-Doe Zantamata',
    '"We are what we repeatedly do. Excellence, then, is not an act, but a habit" \n-Aristotle'
    // '"Do something every day that brings you closer to your goals" \n-Odyssey',
    // '"No alarm clock needed, my passion wakes me" \n-Eric Thomas',
    // '"Make each day a masterpiece" \n-John Wooden'
  ];

  List<String> schoolTask = [
    '"Do not train a child to learn by force or harshness; but direct them to it by what amuses their minds, so that you may be better able to discover with accuracy the peculiar bent of the genius of each." \n-Plato',
    '"Those who educate children well are more to be honored than they who produce them; for these only gave them life, those the art of living well." \n-Aristotle',
    '"Lock up your libraries if you like; but there is no gate, no lock, no bolt that you can set upon the freedom of my mind." \n-Virginia Woolf',
    '"You don’t get what you wish for. You get what you work for" \n-Daniel Milstein',
    '"Educating the mind without educating the heart is no education at all." \n-Aristotle',
    '"A little progress each day adds up to big results" \n-Satya Nani',
    '"Prejudices, it is well known, are most difficult to eradicate from the heart whose soil has never been loosened or fertilised by education: they grow there, firm as weeds among stones." \n-Charlotte Brontë',
    '"The way to get started is to quit talking and begin doing" \n-Walt Disney',
    '"It’s hard to beat a person who never gives up" \n-Ruth',
    '"Give a bowl of rice to a man and you will feed him for a day. Teach him how to grow his own rice and you will save his life." \n-Confucius'
    // '"If you get tired, learn to rest not to quit" \n-Banksy',
    // '"Will it be easy? Nope. Will it be worth it? Absolutely!" \n-mindfullyglam',
    // '"If there is no struggle, there is no progress" \n-Frederic Douglass',
  ];

  List<String> entertainment = [
    '"Movies can and do have tremendous influence in shaping young lives in the realm of entertainment towards the ideals and objectives of normal adulthood." \n-Walt Disney',
    '"If you make customers unhappy in the physical world, they might each tell 6 friends. If you make customers unhappy on the Internet, they can each tell 6,000 friends." \n-Jeff Bezos',
    '"I adore art… when I am alone with my notes, my heart pounds and the tears stream from my eyes, and my emotion and my joys are too much to bear" \n-Guiseppe Verdi',
    '"Success is not the key to happiness. Happiness is the key to success. If you love what you are doing, you will be successful." \n-Albert Schweitzer',
    '"Don’t say anything online that you wouldn’t want plastered on a billboard with your face on it." \n-Erin Bury',
    '"Today is life-the only life you are sure of. Make the most of today. Get interested in something. Shake yourself awake. Develop a hobby. Let the winds of enthusiasm sweep through you. Live today with gusto." \n-Dale Carnegie',
    '"The finest thing about a hobby is that you can\'t do any pretending about it. You either like it or you don\'t." \n-Dorothy Draper',
    '"But a hobby, like a habit, makes you forget about important things in life." \n-Margo Kaufman',
    '"No matter what your age or your life path, whether making art is your career or your hobby or your dream, it is not too late or too egotistical or too selfish or too silly to work on your creativity." \n-Julia Cameron',
    '"Surround yourself with what you love, whether it\'s family, pets, keepsakes, music, plants, hobbies, whatever." \n-George Carlin'
  ];

  List<String> mentalHealth = [
    '"You don’t have to control your thoughts. You just have to stop letting them control you." \n-Dan Millman',
    '"One small crack does not mean that you are broken, it means that you were put to the test and you didn’t fall apart" \n-Linda Poindexter',
    '"Self-care is how you take your power back" \n Lalah Delia',
    '"My dark days made me strong. Or maybe I already was strong, and they made me prove it" \n-Emery Lord',
    '"Happiness can be found even in the darkest of times, if one only remembers to turn on the light" \n-Albus Dumbledore',
    '"You spend most of your life inside your head. Make it a nice place to be" \n-zazzle.com',
    '"The sun will rise and we will try again" \n-redbubble.com',
    '"You have changed - We are supposed to" \n-storenvy.com',
    '"Do not compare your life to others. There is no comparison between the sun and the moon. They both shine bright when it is their time" \n-stephanniechinnart',
    '"Set peace of mind as your highest goal, and organize your life around it.” \n Brian Tracy',
  ];

  List<String> physicalHealth = [
    '"You dream. You plan. You reach. There will be obstacles. There will be doubters. There will be mistakes. But with hard work, with belief, with confidence and trust in yourself and those around you, there are no limits." \n-Michael Phelps',
    '"If something stands between you and your success, move it. Never be denied." \n-Dwayne "The Rock" Johnson',
    '"A champion is someone who gets up when they can’t." \n-Jack Dempsey',
    '"You have to think it before you can do it. The mind is what makes it all possible." \n-Kai Greene',
    "'The only person you are destined to become is the person you decide to be.' \n-Ralph Waldo Emerson",
    '"You must not only have competitiveness but ability, regardless of the circumstance you face, to never quit." \n-Abby Wambach',
    '"It doesn’t matter what you’re trying to accomplish. It’s all a matter of discipline." \n-Wilma Rudolph',
    '"Most people fail, not because of lack of desire but because of lack of commitment." \n-Vince Lombardi',
    '"Some people want it to happen, some wish it would happen, others make it happen." \n-Michael Jordan',
    '"Hard work beats talent when talent doesn’t work hard." \n -Tim Notke'
  ];

  List<String> career = [
    '"Sometimes you can\'t see yourself clearly until you see yourself through the eyes of others" \n-Ellen DeGeneres',
    '"Take up one idea. Make that one idea your life -- think of it, dream of it, live on that idea. Let the brain, muscles, nerves, every part of your body be full of that idea, and just leave every other idea alone. This is the way to success." \n-Swami Vivekananda',
    '"Find out what you like doing best, and get someone to pay you for doing it." \n-Katharine Whitehorn',
    '"The only way to do great work is to love what you do. If you haven\'t found it yet, keep looking. Don\'t settle." \n-Steve Jobs',
    '"There is no passion to be found playing small—in settling for a life that is less than the one you are capable of living." \n-Nelson Madela',
    '"I was always looking outside myself for strength and confidence, but it comes from within. It is there all the time." \n-Anna Freud',
    '"Without leaps of imagination or dreaming, we lose the excitement of possibilities. Dreaming, after all is a form of planning." \n-Gloria Steinem',
    '"Opportunities don\'t happen, you create them." \n-Chris Grosser',
    '"It\'s not what you achieve, it\'s what you overcome. That\'s what defines your career" \n-Carlton Fisk',
    '"The best way to predict the future is to create it." \n-Abraham Lincoln'
  ];

  //**variable Holders */
  List<String> splitWords = [];
  var quotesWordsOccurence = List.generate(keyWords.length, (index) => 0);

  //concatenate both string
  String searchText = title + ' ' + description;

  //split serchText into individual words, removing extraCharacters
  splitWords = searchText.split(RegExp(r'[,.?!\s-/_|()]+'));

//Search all string from the keyWord list
  for (int i = 0; i < splitWords.length; i++) {
    for (int j = 0; j < keyWords.length; j++) {
      if (keyWords[j].toLowerCase().contains(splitWords[i].toLowerCase())) {
        quotesWordsOccurence[j] += 1;
      }
    }
  }

//Rank and index holder of most index with the same words
  int highestOccurence = 0;
  int highestOccurenceIndex = 0;
  print(quotesWordsOccurence);
  print(highestOccurenceIndex);

//Search highest Occurance
  for (int k = 0; k < quotesWordsOccurence.length; k++) {
    if (highestOccurence < quotesWordsOccurence[k]) {
      highestOccurence = quotesWordsOccurence[k];
      highestOccurenceIndex = k;
    }
  }

//genate a random number for quotesIndex
  var randomNum = new Random();
  int randomIndex = randomNum.nextInt(9);

//searchQuotes in specific list
  switch (highestOccurenceIndex) {
    //search quotes in Daily task
    case 0:
      quote = dailyTask[randomIndex];
      break;
    //search quotes in School Task
    case 1:
      quote = schoolTask[randomIndex];
      break;
    //search quotes in Entertainment
    case 2:
      quote = entertainment[randomIndex];
      break;
    //search quotes in Mental health
    case 3:
      quote = mentalHealth[randomIndex];
      break;
    //search quotes in Physical health
    case 4:
      quote = physicalHealth[randomIndex];
      break;
    //search quotes in Career
    case 5:
      quote = career[randomIndex];
      break;
  }
  return quote;
}
