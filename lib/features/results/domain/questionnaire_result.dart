class QuestionnaireResult {
  final String id;
  final double score;
  final Map<String, String> answers;
  final DateTime createdAt;

  const QuestionnaireResult({
    required this.id,
    required this.score,
    required this.answers,
    required this.createdAt,
  });

String get riskLevel {
  if (score <= 4) {
    return 'High'; // symptoms exist → needs consultation
  } else if (score <= 7) {
    return 'Medium'; // may need further screening
  } else {
    return 'Low'; // child is fine → no issues
  }
}

}
