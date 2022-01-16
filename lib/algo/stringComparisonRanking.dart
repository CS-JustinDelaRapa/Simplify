import 'dart:core';
import 'dart:math';

String getQuote(String title, String description) {
  //return value
  String quote = '';

  //**List of Keywords */
  List<String> keyWords = [
    //daily task
    'Home House Room Kitchen Garden Household Chores Clean Cook Grocery Market Shop Food Duty Housework Walk Eat Feed Errand Sleep Laundry Dust Sweep Trash Vacuum Lawn Car Pets Garage Dishes Clothing Closet Routine Pattern Habit Wipe Recycle Mop Refrigerator Cabinets Furniture Mattress Duvet Pillow Windows Dishwasher Shower Bath Nap Brush Dressed Arrive Asleep Dinner Lunch Breakfast Tidy Drive Makeup Wash Hang Iron Plant Clutter Fold Sanitize regularly Boil Budget Buy Money morning bathing wealth poverty capitalism industrialism rush shift self reflection women distinction urban reality rural area factory convention studies enlightenment discourse communication cognitive processing behavior conservative vast wasteland personal relationship representative democracy daily living newspaper day regular today weekday tabloid monthly morning frequent quotidian workday paper Thursday Friday Sunday Tuesday Monday noon afternoon weekend weekly circulation news Wednesday daily continuously responses mornings unverified accounts daily email newsletter horoscopes columnists numbing commute commuter nighttime anytime anywhere continually daybook informal midday tomorrow circadian dailies daylight forenoon fortnight midnight according payday intraday Saturday midweek local midafternoon multiday post quoted tonight yesterday sources official citing herald quoting sunrise telephone source headline commentary bulletin report mail noonday call month published daybreak predate ministry someday recent speaking weeknight diel biweekly nightly yearly bimonthly sunset workweek washday nightfall constant continual continuous morning tide dusk periodically twilight routine broadsheet  solstice newsprint gloaming sundown downtime overnight mornings yesteryear occasional yesterevening evenness frequently horoscope judgment commutes uptime update calendar fore gossip newscasts period sail sunup lunchtime dayspring tedium annually tomorrow cockcrow unending evening intolerable ward week unceasing digests inauguration blooms regularity midevening clock nighties newsroom ceasing unbearable endless basis stories valentine drudgery latter newyear saints time mealtime semiweekly semimonthly habituates termly freesheet repots shoptalk redtop canonical date rainy sidereal quarter rag current solar quarter century leap reverse specious frame present bronze classify advertisement moon Christmas everyday multivitamin crossword puzzle',
    //school Task
    'Schoolwork Activity Assignment Review Test Exam Tutorial Essay Quiz Recap Study Memorize Familiarize Learn Think Homework Exercises Project Lesson Thesis Paperwork Submit Pass Create Search Research Document Upload Download Write Read Master School University Draw Score Grade Mark Compute Tackle Understand Notebook Academic Competition Event Portfolio Practicum Presentation Group Coursework English Science Math Handwriting Speech Debate Algebra Geometry Geography Physics Chemistry Biology Economics Literature Poetry Poem Recitation Vocabulary Grammar Botany Astronomy Ecology Meteorology Calculus Accounting Statistics Trigonometry History Sociology Anthropology Genealogy Philosophy Logic Programming Computer Arts Google Word Excel PDF Edit Library education college classroom student academy kindergarten educate seminary primary curriculum conservatory middle secondary schoolhouse vocational elementary institution public shoal faculty private undergraduate campus class varsity gymnasium preschool prep schoolteacher lyceum schooling schoolroom crammer system technical scholastic pointillism teach civilize cultivate Harvard reading districtwide junior extracurricular activities report pre-kindergarten nursery pupil guidance comprehensive homeschool international baccalaureate association tuition achievement collegiate academically portable preparatory PE educator seniors universities organization scholarship afterschool building schoolboy  professor schoolmate law coeducation preceptor chalkboard upperclassman interschool schoolbook sophisticate instructor sophomore scholar intramural alumna multiversity tutor schoolkid cafeteria enrolled schoolchild instructional attending schoolgirl caliph courses community indoctrination hall queens youth classmate pedagogue trinity center ottomans established studying mathematics studied environment serve addition chalkface yearbook ratio lecture room poet postsecondary animal secretarial ashcan veterinary language text rule legacy board alumnus alternative uniform district summer homeroom deans list tech military models fastener binder headmaster charm eraser blackboard semester bowl humanities finish principal interscholastic proms athletics dropout textbooks superintendents valedictorian matriculation truants headmistress administrator schoolyard technological art prekindergarten lunchroom modern precalculus evaluation examination innovative innovate innovation excellence nurture nurtures nurturing institution bullying academe academia vale dean salutatorian laboratory numbering anagrams worksheet backpack arithmetic bookmark calculator crayons desk chalk experiment encyclopedia dictionary glossary glue highlighter markers memorization printer protractor poster',
    // Entertainment
    'Facebook YouTube Twitter Instagram Messenger Chat Jamming Sing Music Paint Dance Fun Games Enjoy Shopping Mall Message Friends Family Relatives Leisure Travel Trip Beach TV Movie Watch Park Circus Carnival Books Concerts Festival Fairs Show Museums KDrama Netflix Picnic Party Bake Vacation Staycation Hotel Restaurant Camping Anime fiction Cartoons amusement recreation edutainment nightlife television storytelling theater multimedia game cinema film animation comedy gaming theatre entertainment broadcasting digital Hollywood audio visual enjoyment banquet consumer electronics videogames concert merchandising multiplatform entertaining beverage rides pop culture console interactivity sporting auditorium associated press  stadium wholesome immersive surround sound video online gambling theme radio outdoor socializing solo musical casual dining entertained musician experiential signage ringtone animatronic watersport fantasy ancillary celebrity preshow entertain audience theatrical drama performance ceremony hospitality opera fencing cooking remix audiobook novel distraction diversion ethics running tourist hickory horseracing bamboo cartage racing colosseum museology tournament hanging clown puppet productions network marble cognition birthday paramount chef rhythm boredom universal cable jazz studio amplifier broadcast choir creative orchestra channel exclusive commercial  ShowTime  internet publishing pharaoh showcase marketplace pictures website mega outlets ticket poker bingo venture magazine blockbuster entertainer distributor featured brand piggyback croquet corporate paintball touchstone syndicated features series competitive cabaret Sudoku font comics limerick superheroes audiovisual superman matrix hitchhikers manga caricature adventure record genre jester phrases artificial intelligence obscenity philosophical hunchback pole karaoke joke parody irony polymer farce popcorn roman empire masque hopscotch cultural revolution revolutionary pilgrim motorsports tablet civilization gameplan emperors saga allegory acculturation attractions odyssey kiddie actor handover showbiz catering dreamtime purchase sitcom palace humiliation applaud dickens amuse guitar relieve telefilm leave content operetta surf checklist refreshment monologue sailing bubble stagecraft buffet rating escape instrument classical amenities opry banqueting mobile funfair arcade gourmet ticketing lifestyle retail dancing folk oater rock melodrama magic plug electricity teleshow ensemble personification voice marvel spiderman wolverine horror',
    //mental health
    'Stress Anxiety Depression Sad Happy Free Therapy Hate Poor Ill Disorder Paranoid Suffer Mood Emotion Mad Angry Doctor Therapist Socialize Sweetheart Trauma Memory Incapable Psychological Spiritual Abuse Heal Neglect Insanity Crazy Afraid Scared Troubled Unbalanced Mental Disturbed Derangement Sick Phobia Compulsive Obsession Difficulties Optimist Issues Problem Pessimist Hardships Negative Positive Hinder Suicide Energy Concentrate Distress Wellness Alone Lonely Addiction Grief Lack Failure Chronic Crisis Offend Burnout illness welfare psychotherapy medical psychiatric disabilities counseling practitioner rehabilitation behavioral substance clinic physicians autism dualism soul condition happiness spirituality creativity esteem psychiatrists outpatient inpatient homelessness correctional dementia alcoholism psychologists recidivism childcare habilitation hospice counselors perinatal bereavement caregiver obstetric geriatric methadone hospital Medicaid midwifery neuropsychology psychology  incarceration detoxification truancy epilepsy psychopathology chaplaincy pediatric physician prisons maternity adolescents diagnoses parenting opinion convalescent aftercare caseworker alcoholics batterer psychologist psychiatrist love treatment  fear patient treating prevention drugs drug disability risk serious vandalism workplace social aids continuum awareness neurological suffering severe benefits critical inadequate protection mentally personality  bipolar retardation clinical posttraumatic intervention depressive schizophrenia puerperal psychosis catatonic sex offender fetal syndrome diabetes bulimia nervosa holistic respiratory diagnosis complications reproductive effectiveness adequate anthropological life religious sociological resilience soundness physiotherapy imagination humor physiotherapist consciousness jazzercise exergaming efficacy monism intellectual susceptibility caffeine perspiration viability religion vitality vital ability mindfulness homeostasis grimace robustness powerlessness inhabitable fortitude loneliness competence capability smilingly competency cranky soulful sturdiness smiler livelihood unable aptness exhaust exhaustion ontology morale sprightly anemic prowess dominance developmental cheerfulness empowerment liveliness proficiency enliven potentiality limber virtuosity recondition disorderliness livingness rationalism hairlessness coping traumatic mind broken exhausting exhausted confused freak psycho screwed demented weird nuts dumb spastic loony Embarrassed embarrassing violence isolated abusive abnormal Alzheimer Nervous Muppets Madness Irrational Insecure Helpless Halfwit Hallucinating Hallucinations Vulnerability Outcast Panicked Perverted Schizophrenic Vulnerable Uncomfortable Stigma sadness deranged excluded empty obsessive abused defiant suicidal anorexia pervasive addict addicted lunatic',
    //physical health
    'Play Sports physically bodybuilding movement Basketball Volleyball Football Soccer Badminton Tennis Exercise Drink Detox Diet Jog Gym Run Runs Walk Walks Vegetables Balance Fruits Fit Cardio Weights Body Thin Overweight Shape Muscles Abs Meditate Yoga Hygiene Bicycle Hiking Biking Swim Swims Swimming Aerobic Dietary Jump Workouts Workout Athletes Athlete Calories Fats Portion Intake Track Squats Squat pushup Pushups Lunges Burpees Rope Twists Bodyweight Hydrated Carbs Fiber Protein obesity physical fitness disease diseases blood pressure Penetration provider medicine design unexercised aerobics exercisable policy warm down stretch breathlessness cardiopulmonary muscle strength machine breathe heavily go mass sweatpants weight loss improve splint release shortness breath marathon hike gymnastic hiker walker spacewalk walkabout waddle footsore stride ambulation ambulate perambulate tread developing slog walkathon bushwalk motion locomotion locomotor cramps vagrant charter sidewalk traipse footstep step racewalking boardwalk pace immunity incorporeal biophysics footpath toddle metaphysical footfall biotechnology safety bipedalism musclebound genetic predisposition nutrition sweats sweat nature supersymmetry bodybuilder antigen vaccine harmless fitter salutary strong beneficial harmful innocuous  noxious shamble legs leg shoulder biceps bicep triceps trice resistance quadriceps back glutes hips  pandemic lockstep scenery spectrum move radiology ball bike otology pathogen pyramid vaccination outbreak condom lateral frontal push pull checkup hypochondriasis indispose invalidism phenolic compound athletic build stand attractive cardiovascular injure unfit waste affliction break constitution conservation cure cruelty decline debility frailty form glow hale infirmity infirm injury treat massage operate trains training deprivation maintain metabolism shank mare duck sore gain gains sport intentional dunk lift lifts lifting sweaty climb climbing pound pounds pavement tire whey creatine roller raise swing visit volunteering vegetable overwork meditation sunburn heartrate calisthenics strech stretching exergame exergaming perspire relaxation iatrophysics betoil spectator upfield bobsled funanbilism archery mutant genes gene ski  skateboard motocross boxing boxers boxer snorkel snorkelling surfboard rappel shadowbox cheerleader cheerlead diving divers diver dodgeball powerlifting powerlift powerlifter rugby skate ',
    //career
    'Promotion Qualification Job Jobs Hunting Interviews Interview Career Profession Occupation Work Works Field Business Line Internship Graduate Vocation Future  Graduation Employment Pursuit Path Craft Missions Service Posting Office Company Degree Accountancy Engineering Marketing Advertising Programmer Hiring Industry Passionate Entrepreneurship Administration Managers Nursing Bachelor Masters Doctorate Journey Interests Passion Vitae Parttime Entry level tenure professional streak lifetime stint season majors rookie comeback coaching outing illustrious stints brief briefing résumé lifework victories appearances proudest moment lifelong dream retiring scoring undistinguished superstardom postseason aspired famer aspirant graduating highlight reel tenures winningest doubters storied fame league meteoric rise rising professionally professions consummate retire spanned stellar gifted hobby checkered mentored seasons notched excelled prolific retired specialty specialization specialism progress progression procession advance advancement winning earned successful fortune success debut team completing outstanding impressive earning started credited experience experienced accomplished apprenticeship derail corporation stardom avocation collegian endeavors traveler mentor mentorship pursuits itinerant retirement wayfarer wayfaring byway voyage travail accomplishment trophy trophies accomplishments prance rank ranks aspirations dreams gallop excursion outflank expedition hobbies traversal towpath caravan canter cursus itinerary ambitions ambition route thoroughfare thruway jaunt reign talents talent highwayman tourism tram peregrine autobiography hackney cruise circumnavigation ridgeway pathless retires carriageway carousel tinker trance switchback notching pacer pathway snowshoe itinerate librarianship diploma vagabond peregrination freshman forties  bests prodigy protégé superstar aptitude biography triumphs filmography adulthood greatness pinnacle skill skills renaissance franchise musher contraflow Roadless horseback stockman hypertravel horsemanship peregrinate crew outride roadwork swansong rideable journeywork trekker underachiever métier colligate roadworthy ridden traineeship overachiever equestrianism overcall luggage scenic equestrian sales average mirabilis alma mater literacy bloomer resource management calling appointment collaboration delegation employability incumbency opportunity portfolio sustenance architect architecture workload prospects prospect economist butcher carpenter cashier businessman businesswoman businessperson secretary lawyer police receptionist politician photographer teacher surgeon neurosurgeon multinational freelance leadership stakeholder efflorescence apotheosis aspire prime resign investment caliber ',
  ];
  //**List of Quotes */
  List<String> dailyTask = [
    '"Your future is found in your daily routine. Successful people do daily what others do occasionally" \n-Paula White',
    '"Many of life’s failures are people who did not realize how close they were to success when they gave up" \n-Thomas A. Edison',
    '"Think in the morning. Act in the noon. Eat in the evening. Sleep in the night" \n-William Blake',
    '"Get busy living or get busy dying." \n-Stephen King',
    '"Money and success don’t change people; they merely amplify what is already there." \n-Will Smith',
    '"Smile in the mirror. Do that every morning and you will start to see a big difference in your life" \n-Yoko Ono',
    '"Your time is limited, so don’t waste it living someone else’s life. Don’t be trapped by dogma – which is living with the results of other people’s thinking." \n-Steve Jobs',
    '"Your future is created by what you do today, not tomorrow" \n-Robert Kiyosaki',
    '"Every morning starts a new page in your story. Make it a great one today" \n-Doe Zantamata',
    '"We are what we repeatedly do. Excellence, then, is not an act, but a habit" \n-Aristotle',
    '"There are two types of people who will tell you that you cannot make a difference in this world; those who are afraid to try and those who are afraid you will succeed." \n- Ray Goforth',
    '"Character cannot be developed in ease and quiet. Only through experience of trial and suffering can the soul be strengthened, ambition inspired, and success achieved." \n- Helen Keller',
    '“People who are crazy enough to think they can change the world, are the ones who do.” \n- Rob Siltanen',
    '“Move out of your comfort zone. You can only grow if you are willing to feel awkward and uncomfortable when you try something new.” \n- Brian Tracy',
    '“We must be willing to let go of the life we planned so as to have the life that is waiting for us.” \n– Joseph Campbell',
    '“For every reason it’s not possible, there are hundreds of people who have faced the same circumstances and succeeded.”  \n– Jack Canfield',
    '“If you are working on something that you really care about, you don’t have to be pushed. The vision pulls you.” \n– Steve Job',
    '“Successful people do what unsuccessful people are not willing to do. Don’t wish it were easier; wish you were better.” \n-Jim Rohn',
    '“What you get by achieving your goals is not as important as what you become by achieving your goals.” \n-Zig Ziglar',
    '“You don\'t always need a plan. Sometimes you just need to breathe, trust, let go and see what happens.” \n-Mandy Hale',
    // '"Do something every day that brings you closer to your goals" \n-Odyssey',
    // '"No alarm clock needed, my passion wakes me" \n-Eric Thomas',
    // '"Make each day a masterpiece" \n-John Wooden'
  ];

  List<String> schoolTask = [
    '"Do not train a child to learn by force or harshness; but direct them to it by what amuses their minds, so that you may be better able to discover with accuracy the peculiar bent of the genius of each." \n- Plato',
    '"Those who educate children well are more to be honored than they who produce them; for these only gave them life, those the art of living well." \n- Aristotle',
    '"Lock up your libraries if you like; but there is no gate, no lock, no bolt that you can set upon the freedom of my mind." \n- Virginia Woolf',
    '"You don’t get what you wish for. You get what you work for" \n- Daniel Milstein',
    '"Educating the mind without educating the heart is no education at all." \n- Aristotle',
    '"A little progress each day adds up to big results" \n- Satya Nani',
    '"In school, you’re taught a lesson and then given a test. In life, you’re given a test that teaches you a lesson." \n– Tom Bodett',
    '"The way to get started is to quit talking and begin doing" \n- Walt Disney',
    '"What makes a child gifted and talented may not always be good grades in school, but a different way of looking at the world and learning." \n– Chuck Grassley',
    '"Give a bowl of rice to a man and you will feed him for a day. Teach him how to grow his own rice and you will save his life." \n- Confucius'
    // '"If you get tired, learn to rest not to quit" \n-Banksy',
    // '"Will it be easy? Nope. Will it be worth it? Absolutely!" \n-mindfullyglam',
    // '"It’s hard to beat a person who never gives up" \n-Ruth',
  ];

  List<String> entertainment = [
    '"Movies can and do have tremendous influence in shaping young lives in the realm of entertainment towards the ideals and objectives of normal adulthood." \n- Walt Disney',
    '"If you make customers unhappy in the physical world, they might each tell 6 friends. If you make customers unhappy on the Internet, they can each tell 6,000 friends." \n- Jeff Bezos',
    '"I adore art… when I am alone with my notes, my heart pounds and the tears stream from my eyes, and my emotion and my joys are too much to bear" \n- Guiseppe Verdi',
    '"Success is not the key to happiness. Happiness is the key to success. If you love what you are doing, you will be successful." \n- Albert Schweitzer',
    '"Don’t say anything online that you wouldn’t want plastered on a billboard with your face on it." \n- Erin Bury',
    '"Retirement gives you the time literally to recreate yourself through a sport, game, or hobby that you always wanted to try or that you haven\'t done in years" \n- Steven D. Price',
    '"The finest thing about a hobby is that you can\'t do any pretending about it. You either like it or you don\'t." \n- Dorothy Draper',
    '"We should make some time in between and organize our life, relax ourselves and spend more time with our family, friends, and pursue our own hobbies." \n- Robert Gallagher',
    '"No matter what your age or your life path, whether making art is your career or your hobby or your dream, it is not too late or too egotistical or too selfish or too silly to work on your creativity." \n- Julia Cameron',
    '"Surround yourself with what you love, whether it\'s family, pets, keepsakes, music, plants, hobbies, whatever." \n- George Carlin'
  ];

  List<String> mentalHealth = [
    '"You don’t have to control your thoughts. You just have to stop letting them control you." \n-Dan Millman',
    '"One small crack does not mean that you are broken, it means that you were put to the test and you didn’t fall apart" \n-Linda Poindexter',
    '"Self-care is how you take your power back" \n-Lalah Delia',
    '"My dark days made me strong. Or maybe I already was strong, and they made me prove it" \n-Emery Lord',
    '"Happiness can be found even in the darkest of times, if one only remembers to turn on the light" \n-Albus Dumbledore',
    '“Emotional pain is not something that should be hidden away and never spoken about. There is truth in your pain, there is growth in your pain, but only if it’s first brought out into the open.” \n— Steven Aitchison',
    '“You can’t control everything. Sometimes you just need to relax and have faith that things will work out. Let go a little and just let life happen.” \n— Kody Keplinger',
    '“Out of suffering have emerged the strongest souls; the most massive characters are seared with scars.” \n— Kahlil Gibran',
    '"Do not compare your life to others. There is no comparison between the sun and the moon. They both shine bright when it is their time" \n-Stephannie Chinn',
    '"Set peace of mind as your highest goal, and organize your life around it.” \n- Brian Tracy',
  ];

  List<String> physicalHealth = [
    '"You dream. You plan. You reach. There will be obstacles. There will be doubters. There will be mistakes. But with hard work, with belief, with confidence and trust in yourself and those around you, there are no limits." \n- Michael Phelps',
    '"If something stands between you and your success, move it. Never be denied." \n- Dwayne "The Rock" Johnson',
    '"A champion is someone who gets up when they can’t." \n- Jack Dempsey',
    '"You have to think it before you can do it. The mind is what makes it all possible." \n- Kai Greene',
    "'The only person you are destined to become is the person you decide to be.' \n- Ralph Waldo Emerson",
    '"You must not only have competitiveness but ability, regardless of the circumstance you face, to never quit." \n- Abby Wambach',
    '"It doesn’t matter what you’re trying to accomplish. It’s all a matter of discipline." \n- Wilma Rudolph',
    '"Most people fail, not because of lack of desire but because of lack of commitment." \n- Vince Lombardi',
    '"Some people want it to happen, some wish it would happen, others make it happen." \n- Michael Jordan',
    '"Hard work beats talent when talent doesn’t work hard." \n -Kevin Durant'
  ];

  List<String> career = [
    '"Sometimes you can\'t see yourself clearly until you see yourself through the eyes of others" \n- Ellen DeGeneres',
    '"Take up one idea. Make that one idea your life -- think of it, dream of it, live on that idea. Let the brain, muscles, nerves, every part of your body be full of that idea, and just leave every other idea alone. This is the way to success." \n- Swami Vivekananda',
    '"Find out what you like doing best, and get someone to pay you for doing it." \n- Katharine Whitehorn',
    '"The only way to do great work is to love what you do. If you haven\'t found it yet, keep looking. Don\'t settle." \n- Steve Jobs',
    '"There is no passion to be found playing small—in settling for a life that is less than the one you are capable of living." \n- Nelson Mandela',
    '"I was always looking outside myself for strength and confidence, but it comes from within. It is there all the time." \n- Anna Freud',
    '"Without leaps of imagination or dreaming, we lose the excitement of possibilities. Dreaming, after all is a form of planning." \n- Gloria Steinem',
    '"Opportunities don\'t happen, you create them." \n- Chris Grosser',
    '"It\'s not what you achieve, it\'s what you overcome. That\'s what defines your career" \n- Carlton Fisk',
    '"The best way to predict the future is to create it." \n- Abraham Lincoln'
  ];

  //**variable Holders */
  List<String> splitWords = [];
  var quotesWordsOccurence = List.generate(keyWords.length, (index) => 0);

  //concatenate both string
  String searchTextRaw = title + ' ' + description;
  String searchText = searchTextRaw.trim();

  //split serchText into individual words, removing extraCharacters
  splitWords =
      searchText.split(RegExp(r'[,.?!\s-/_|()]+', caseSensitive: false));

//Search all string from the keyWord list
  for (int i = 0; i < splitWords.length; i++) {
    for (int j = 0; j < keyWords.length; j++) {
      RegExp exp =
          new RegExp("\\b" + splitWords[i] + "\\b", caseSensitive: false);
      bool containe = exp.hasMatch(keyWords[j]);
      if (containe) {
        quotesWordsOccurence[j] += 1;
      }
    }
  }

//Rank and index holder of most index with the same words
  int highestOccurence = 0;
  int highestOccurenceIndex = 0;

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
