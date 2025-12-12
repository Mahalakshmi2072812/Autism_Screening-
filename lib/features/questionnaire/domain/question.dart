class Question {
  final String id;
  final String text;
  final String? taText;

  const Question({required this.id, required this.text, this.taText});
}

const List<Question> kQuestions = [
  Question(
    id: 'q1',
    text: "Cried immediately after birth.",
    taText: 'குழந்தை பிறந்த உடனேயே அழுதது.',
  ),
  Question(
    id: 'q2',
    text: "Held head up by 2 months of age.",
    taText: 'குழந்தையால் 2 மாத வயதிலேயே தலையை நிமிர்த்த முடிந்தது.',
  ),
  Question(
    id: 'q3',
    text: "Turned onto the stomach between 4–6 months.",
    taText: 'குழந்தையை அதன் பெயர் சொல்லி அழைக்கும்போது அது பதிலளிக்கிறது.',
  ),
  Question(
    id: 'q4',
    text: "Started crawling between 7–9 months.",
    taText: 'குழந்தை 7 முதல் 9 மாதங்களுக்குள் தவழத் தொடங்கியது.',
  ),
  Question(
    id: 'q5',
    text: "Sat without support by 8–9 months.",
    taText: 'குழந்தை 8-9 மாதங்களுக்குள் யாருடைய உதவியும் இல்லாமல் உட்கார முடிந்தது.',
  ),
  Question(
    id: 'q6',
    text: "Held onto objects and walked around 11–12 months.",
    taText: 'குழந்தை எதையாவது பிடித்துக்கொண்டு 11-12 மாதங்களில் நடக்கத் தொடங்கியது.',
  ),
  Question(
    id: 'q7',
    text: "Makes eye contact.",
    taText: 'குழந்தையால் கண்களைப் பார்த்துப் பேச முடிகிறது.',
  ),
  Question(
    id: 'q8',
    text: "Said single words between 10–12 months.",
    taText: 'குழந்தை 10 முதல் 12 மாதங்களுக்குள் ஒற்றை வார்த்தைகளைப் பேசத் தொடங்கியது',
  ),
  Question(
    id: 'q9',
    text: "The Child Throws tantrums.",
    taText: 'குழந்தைக்குக் கோபமூட்டும் பிடிவாதப் போக்குகள் ஏற்படுகிறது',
  ),
  Question(
    id: 'q10',
    text: "Responds when his/her name is called.",
    taText: 'குழந்தையை அதன் பெயர் சொல்லி அழைக்கும்போது அது பதிலளிக்கிறது.',
  ),
];
