class Post {
  String? postID;
  final String title;
  final String type;
  final String date;
  final String time;
  final int maxParticipants;
  final int currentParticipants;
  final String requirements;
  final String description;
  final String image;
  final String creatorID;
  final Map<String, double> location;

  Post(
      {this.postID,
      required this.title,
      required this.type,
      required this.date,
      required this.time,
      required this.maxParticipants,
      required this.requirements,
      required this.description,
      required this.image,
      required this.creatorID,
      required this.currentParticipants,
      required this.location});

  Map<String, dynamic> toJson() {
    return {
      'title': this.title,
      'type': this.type,
      'date': this.date,
      'time': this.time,
      'maxParticipants': this.maxParticipants,
      'requirements': this.requirements,
      'description': this.description,
      'image': this.image,
      'creatorID': this.creatorID,
      'currentParticipants': this.currentParticipants,
      'location': this.location
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    Map<String, double> parsedLocation = {};
    if (json['location'] != null) {
      json['location'].forEach((key, value) {
        parsedLocation[key] = value.toDouble();
      });
    }

    return Post(
        postID: json['postID'],
        title: json['title'],
        type: json['type'],
        date: json['date'],
        time: json['time'],
        maxParticipants: json['maxParticipants'],
        requirements: json['requirements'],
        description: json['description'],
        image: json['image'],
        creatorID: json['creatorID'],
        currentParticipants: json['currentParticipants'],
        location: parsedLocation);
  }
}
