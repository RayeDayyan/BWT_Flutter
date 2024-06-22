class Note {
  final int? id;
  String? note;
  String? status;
  String? date;

  Note({
    this.id,
    this.note,
    this.status,
    this.date,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      note: json['note'],
      status: json['status'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'note': note,
      'status': status,
      'date': date,
    };
  }

  void updateNote(String newNote) {
    if (newNote.length <= 255) {
      note = newNote;
    }
  }

  void updateStatus(String newStatus) {
    if (newStatus == 'Pending' || newStatus == 'Completed') {
      status = newStatus;
    }
  }

  void updateDate(String newDate) {
    date = newDate;
  }
}