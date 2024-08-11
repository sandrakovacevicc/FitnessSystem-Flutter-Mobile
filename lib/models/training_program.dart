class TrainingProgram {
  final int trainingProgramId;
  final String name;
  final String description;
  final int trainingDurationInMinutes;
  final String trainingType;

  TrainingProgram({
    required this.trainingProgramId,
    required this.name,
    required this.description,
    required this.trainingDurationInMinutes,
    required this.trainingType,
  });

  factory TrainingProgram.fromJson(Map<String, dynamic> json) {
    return TrainingProgram(
      trainingProgramId: json['trainingProgramId'],
      name: json['name'],
      description: json['description'],
      trainingDurationInMinutes: json['trainingDurationInMinutes'],
      trainingType: json['trainingType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trainingProgramId': trainingProgramId,
      'name': name,
      'description': description,
      'trainingDurationInMinutes': trainingDurationInMinutes,
      'trainingType': trainingType,
    };
  }
}
