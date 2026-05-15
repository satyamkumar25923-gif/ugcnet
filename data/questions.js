export const questionBank = [
  // 2025 (Mock/Predicted)
  {
    id: "2025_1",
    year: "2025",
    paper: "Paper 1",
    subject: "General",
    topic: "ICT",
    question: "Which of the following technologies is primarily used for generating human-like text in modern AI assistants?",
    options: ["Blockchain", "Large Language Models (LLMs)", "Quantum Computing", "Edge Computing"],
    correctAnswer: "Large Language Models (LLMs)",
    explanation: "LLMs like GPT-4 are the core technology behind modern text-generative AI."
  },
  // 2024
  {
    id: "2024_1",
    year: "2024",
    paper: "Paper 1",
    subject: "General",
    topic: "Environment",
    question: "The target for renewable energy capacity in India by 2030 is:",
    options: ["175 GW", "450 GW", "500 GW", "300 GW"],
    correctAnswer: "500 GW",
    explanation: "India has set a target of 500 GW of non-fossil fuel based energy capacity by 2030."
  },
  // 2023
  {
    id: "2023_1",
    year: "2023",
    paper: "Paper 1",
    subject: "General",
    topic: "Higher Education",
    question: "The National Education Policy (NEP) 2020 aims to increase the Gross Enrolment Ratio in higher education to 50% by which year?",
    options: ["2030", "2035", "2040", "2025"],
    correctAnswer: "2035",
    explanation: "NEP 2020 targets a 50% GER in higher education by 2035."
  },
  // 2022
  {
    id: "2022_1",
    year: "2022",
    paper: "Paper 2",
    subject: "Education",
    topic: "Educational Psychology",
    question: "Who proposed the 'Zone of Proximal Development' (ZPD)?",
    options: ["Jean Piaget", "Lev Vygotsky", "B.F. Skinner", "Jerome Bruner"],
    correctAnswer: "Lev Vygotsky",
    explanation: "Vygotsky's ZPD refers to the difference between what a learner can do without help and what they can do with guidance."
  },
  // 2021
  {
    id: "2021_1",
    year: "2021",
    paper: "Paper 1",
    subject: "General",
    topic: "Research Aptitude",
    question: "A variable that is manipulated by the researcher to observe its effect is called:",
    options: ["Dependent Variable", "Independent Variable", "Confounding Variable", "Control Variable"],
    correctAnswer: "Independent Variable",
    explanation: "The independent variable is the one changed or controlled in a scientific experiment."
  },
  // 2020
  {
    id: "2020_1",
    year: "2020",
    paper: "Paper 1",
    subject: "General",
    topic: "Teaching Aptitude",
    question: "SWAYAM stands for:",
    options: [
      "Study Webs of Active-Learning for Young Aspiring Minds",
      "Smart Ways of Active-Learning for Young Aspiring Minds",
      "Study World of Active-Learning for Young Aspiring Minds",
      "Simple Webs of Active-Learning for Young Aspiring Minds"
    ],
    correctAnswer: "Study Webs of Active-Learning for Young Aspiring Minds",
    explanation: "SWAYAM is an Indian government program designed to achieve the three cardinal principles of Education Policy: access, equity, and quality."
  },
  // 2019
  {
    id: "2019_1",
    year: "2019",
    paper: "Paper 1",
    subject: "General",
    topic: "Communication",
    question: "Effective communication inside the classroom is:",
    options: ["Direct", "Critical", "Empathetic", "Abstract"],
    correctAnswer: "Empathetic",
    explanation: "Empathy in communication helps in understanding students better and facilitating effective learning."
  },
  // 2018
  {
    id: "2018_1",
    year: "2018",
    paper: "Paper 2",
    subject: "Education",
    topic: "Philosophy of Education",
    question: "Which school of philosophy emphasizes 'learning by doing'?",
    options: ["Idealism", "Naturalism", "Pragmatism", "Realism"],
    correctAnswer: "Pragmatism",
    explanation: "Pragmatism, led by thinkers like John Dewey, emphasizes practical experience and problem-solving."
  },
  // 2017
  {
    id: "2017_1",
    year: "2017",
    paper: "Paper 1",
    subject: "General",
    topic: "Logical Reasoning",
    question: "In the series 2, 6, 12, 20, 30, ?, the next number is:",
    options: ["40", "42", "44", "46"],
    correctAnswer: "42",
    explanation: "The differences are 4, 6, 8, 10, so the next difference is 12. 30 + 12 = 42."
  },
  // 2016
  {
    id: "2016_1",
    year: "2016",
    paper: "Paper 1",
    subject: "General",
    topic: "ICT",
    question: "Which of the following is not an output device?",
    options: ["Printer", "Speaker", "Monitor", "Keyboard"],
    correctAnswer: "Keyboard",
    explanation: "Keyboard is an input device."
  },
  // 2015
  {
    id: "2015_1",
    year: "2015",
    paper: "Paper 1",
    subject: "General",
    topic: "Higher Education",
    question: "The first Open University in India was established in which state?",
    options: ["Andhra Pradesh", "Delhi", "Maharashtra", "Tamil Nadu"],
    correctAnswer: "Andhra Pradesh",
    explanation: "B.R. Ambedkar Open University was established in 1982 in Hyderabad, Andhra Pradesh."
  }
];

// Function to get questions by year
export const getQuestionsByYear = (year) => {
  return questionBank.filter(q => q.year === year);
};

// Function to get questions by paper
export const getQuestionsByPaper = (paper) => {
  return questionBank.filter(q => q.paper === paper);
};
