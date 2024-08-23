class TrainingProgram {
  final int trainingProgramId;
  final String? name;
  final String? description;
  final int? trainingDurationInMinutes;
  final String? trainingType;

  TrainingProgram({
    required this.trainingProgramId,
    this.name,
    this.description,
    this.trainingDurationInMinutes,
    this.trainingType,
  });

  factory TrainingProgram.fromJson(Map<String, dynamic> json) {
    return TrainingProgram(
      trainingProgramId: json['trainingProgramId'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      trainingDurationInMinutes: json['trainingDurationInMinutes'] ?? 0,
      trainingType: json['trainingType'] ?? '',
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
