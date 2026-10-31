
import '../models/question.dart';

class QuestionBank {
  static final List<Question> questions = [
    // GENERAL KNOWLEDGE
    Question(
      id: 'gk1',
      categoryId: 'general',
      questionText: 'What is the capital of India?',
      options: ['Mumbai', 'New Delhi', 'Chennai', 'Kolkata'],
      correctAnswerIndex: 1,
    ),
    Question(
      id: 'gk2',
      categoryId: 'general',
      questionText: 'Which is the largest ocean on Earth?',
      options: ['Atlantic', 'Indian', 'Pacific', 'Arctic'],
      correctAnswerIndex: 2,
    ),
    Question(
      id: 'gk3',
      categoryId: 'general',
      questionText: 'How many continents are there?',
      options: ['5', '6', '7', '8'],
      correctAnswerIndex: 2,
    ),
    Question(
      id: 'gk4',
      categoryId: 'general',
      questionText: 'Which planet is called the Red Planet?',
      options: ['Venus', 'Mars', 'Jupiter', 'Mercury'],
      correctAnswerIndex: 1,
    ),
    Question(
      id: 'gk5',
      categoryId: 'general',
      questionText: 'What is the currency of Japan?',
      options: ['Yen', 'Won', 'Dollar', 'Rupee'],
      correctAnswerIndex: 0,
    ),
    Question(
      id: 'gk6',
      categoryId: 'general',
      questionText: 'Which is the largest continent?',
      options: ['Africa', 'Europe', 'Asia', 'Australia'],
      correctAnswerIndex: 2,
    ),
    Question(
      id: 'gk7',
      categoryId: 'general',
      questionText: 'How many days are in a leap year?',
      options: ['364', '365', '366', '367'],
      correctAnswerIndex: 2,
    ),
    Question(
      id: 'gk8',
      categoryId: 'general',
      questionText: 'Which country is famous for the Eiffel Tower?',
      options: ['Italy', 'France', 'Germany', 'Spain'],
      correctAnswerIndex: 1,
    ),
    Question(
      id: 'gk9',
      categoryId: 'general',
      questionText: 'What is the national animal of India?',
      options: ['Lion', 'Elephant', 'Tiger', 'Peacock'],
      correctAnswerIndex: 2,
    ),
    Question(
      id: 'gk10',
      categoryId: 'general',
      questionText: 'Which instrument measures temperature?',
      options: ['Barometer', 'Thermometer', 'Speedometer', 'Compass'],
      correctAnswerIndex: 1,
    ),

    // SCIENCE
    Question(
      id: 's1',
      categoryId: 'science',
      questionText: 'What is the chemical formula of water?',
      options: ['CO2', 'H2O', 'O2', 'NaCl'],
      correctAnswerIndex: 1,
    ),
    Question(
      id: 's2',
      categoryId: 'science',
      questionText: 'Which gas do plants absorb during photosynthesis?',
      options: ['Oxygen', 'Nitrogen', 'Carbon dioxide', 'Hydrogen'],
      correctAnswerIndex: 2,
    ),
    Question(
      id: 's3',
      categoryId: 'science',
      questionText: 'Which organ pumps blood?',
      options: ['Brain', 'Heart', 'Liver', 'Lungs'],
      correctAnswerIndex: 1,
    ),
    Question(
      id: 's4',
      categoryId: 'science',
      questionText: 'What is the center of an atom called?',
      options: ['Electron', 'Nucleus', 'Proton', 'Neutron'],
      correctAnswerIndex: 1,
    ),
    Question(
      id: 's5',
      categoryId: 'science',
      questionText: 'Which vitamin is produced in skin by sunlight?',
      options: ['Vitamin A', 'Vitamin B', 'Vitamin C', 'Vitamin D'],
      correctAnswerIndex: 3,
    ),
    Question(
      id: 's6',
      categoryId: 'science',
      questionText: 'What is the boiling point of water at sea level?',
      options: ['50°C', '75°C', '100°C', '120°C'],
      correctAnswerIndex: 2,
    ),
    Question(
      id: 's7',
      categoryId: 'science',
      questionText: 'What force pulls objects toward Earth?',
      options: ['Magnetism', 'Gravity', 'Friction', 'Electricity'],
      correctAnswerIndex: 1,
    ),
    Question(
      id: 's8',
      categoryId: 'science',
      questionText: 'Which part of a plant absorbs water?',
      options: ['Flower', 'Leaf', 'Roots', 'Stem'],
      correctAnswerIndex: 2,
    ),
    Question(
      id: 's9',
      categoryId: 'science',
      questionText: 'Which gas is most abundant in the atmosphere?',
      options: ['Oxygen', 'Nitrogen', 'Carbon dioxide', 'Argon'],
      correctAnswerIndex: 1,
    ),
    Question(
      id: 's10',
      categoryId: 'science',
      questionText: 'What is the SI unit of electric current?',
      options: ['Volt', 'Watt', 'Ampere', 'Ohm'],
      correctAnswerIndex: 2,
    ),

    // MATHEMATICS
    Question(
      id: 'm1',
      categoryId: 'math',
      questionText: 'What is 12 × 8?',
      options: ['86', '96', '108', '88'],
      correctAnswerIndex: 1,
    ),
    Question(
      id: 'm2',
      categoryId: 'math',
      questionText: 'What is the square root of 144?',
      options: ['10', '11', '12', '14'],
      correctAnswerIndex: 2,
    ),
    Question(
      id: 'm3',
      categoryId: 'math',
      questionText: 'What is 25% of 200?',
      options: ['25', '40', '50', '75'],
      correctAnswerIndex: 2,
    ),
    Question(
      id: 'm4',
      categoryId: 'math',
      questionText: 'What is 15 + 27?',
      options: ['40', '42', '43', '45'],
      correctAnswerIndex: 1,
    ),
    Question(
      id: 'm5',
      categoryId: 'math',
      questionText: 'How many degrees are in a right angle?',
      options: ['45', '60', '90', '180'],
      correctAnswerIndex: 2,
    ),
    Question(
      id: 'm6',
      categoryId: 'math',
      questionText: 'What is 9 squared?',
      options: ['18', '72', '81', '99'],
      correctAnswerIndex: 2,
    ),
    Question(
      id: 'm7',
      categoryId: 'math',
      questionText: 'What is 100 ÷ 4?',
      options: ['20', '25', '30', '40'],
      correctAnswerIndex: 1,
    ),
    Question(
      id: 'm8',
      categoryId: 'math',
      questionText: 'What is the perimeter of a square with side 5 cm?',
      options: ['10 cm', '15 cm', '20 cm', '25 cm'],
      correctAnswerIndex: 2,
    ),
    Question(
      id: 'm9',
      categoryId: 'math',
      questionText: 'What is 7 × 6?',
      options: ['36', '40', '42', '48'],
      correctAnswerIndex: 2,
    ),
    Question(
      id: 'm10',
      categoryId: 'math',
      questionText: 'What is 3 cubed?',
      options: ['9', '18', '27', '36'],
      correctAnswerIndex: 2,
    ),

    // HISTORY
    Question(
      id: 'h1',
      categoryId: 'history',
      questionText: 'In which year did India gain independence?',
      options: ['1945', '1947', '1950', '1952'],
      correctAnswerIndex: 1,
    ),
    Question(
      id: 'h2',
      categoryId: 'history',
      questionText: 'Who was the first Prime Minister of India?',
      options: [
        'Mahatma Gandhi',
        'Jawaharlal Nehru',
        'Sardar Patel',
        'B. R. Ambedkar'
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      id: 'h3',
      categoryId: 'history',
      questionText: 'Who built the Taj Mahal?',
      options: ['Akbar', 'Shah Jahan', 'Babur', 'Aurangzeb'],
      correctAnswerIndex: 1,
    ),
    Question(
      id: 'h4',
      categoryId: 'history',
      questionText: 'Who was known as the Iron Man of India?',
      options: [
        'Subhas Chandra Bose',
        'Sardar Vallabhbhai Patel',
        'Bhagat Singh',
        'Rajendra Prasad'
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      id: 'h5',
      categoryId: 'history',
      questionText: 'In which year did the Indian Constitution come into effect?',
      options: ['1947', '1948', '1950', '1952'],
      correctAnswerIndex: 2,
    ),
    Question(
      id: 'h6',
      categoryId: 'history',
      questionText: 'Who founded the Maurya Empire?',
      options: ['Ashoka', 'Chandragupta Maurya', 'Harsha', 'Samudragupta'],
      correctAnswerIndex: 1,
    ),
    Question(
      id: 'h7',
      categoryId: 'history',
      questionText: 'Which movement did Gandhi launch in 1942?',
      options: [
        'Non-Cooperation',
        'Quit India',
        'Swadeshi',
        'Civil Disobedience'
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      id: 'h8',
      categoryId: 'history',
      questionText: 'Who was the first President of India?',
      options: [
        'Dr. Rajendra Prasad',
        'Jawaharlal Nehru',
        'Zakir Husain',
        'S. Radhakrishnan'
      ],
      correctAnswerIndex: 0,
    ),
    Question(
      id: 'h9',
      categoryId: 'history',
      questionText: 'Which civilization developed along the Indus River?',
      options: [
        'Roman',
        'Indus Valley',
        'Greek',
        'Mayan'
      ],
      correctAnswerIndex: 1,
    ),
    Question(
      id: 'h10',
      categoryId: 'history',
      questionText: 'Who led the Salt March in 1930?',
      options: [
        'Bhagat Singh',
        'Mahatma Gandhi',
        'Subhas Chandra Bose',
        'Bal Gangadhar Tilak'
      ],
      correctAnswerIndex: 1,
    ),
  ];
}
