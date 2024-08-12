class Room{
  final int RoomId;
  final String RoomName;

  Room({required this.RoomId, required this.RoomName});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      RoomId: json['roomId'],
      RoomName: json['roomName'],
    );
  }
}