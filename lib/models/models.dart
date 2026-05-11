class Client {
  final int? id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String address;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Client({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.address,
    required this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? 'Unnamed Client' : name;
  }

  String get initials {
    final parts = fullName.split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'email': email,
        'address': address,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory Client.fromMap(Map<String, dynamic> map) => Client(
        id: map['id'] as int?,
        firstName: (map['first_name'] as String?) ?? '',
        lastName: (map['last_name'] as String?) ?? '',
        phone: (map['phone'] as String?) ?? '',
        email: (map['email'] as String?) ?? '',
        address: (map['address'] as String?) ?? '',
        notes: (map['notes'] as String?) ?? '',
        createdAt: map['created_at'] != null
            ? DateTime.parse(map['created_at'] as String)
            : null,
        updatedAt: map['updated_at'] != null
            ? DateTime.parse(map['updated_at'] as String)
            : null,
      );

  Client copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? address,
    String? notes,
  }) =>
      Client(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        address: address ?? this.address,
        notes: notes ?? this.notes,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );
}

class Horse {
  final int? id;
  final int clientId;
  final String name;
  final String breed;
  final String color;
  final String notes;
  final DateTime createdAt;

  Horse({
    this.id,
    required this.clientId,
    required this.name,
    this.breed = '',
    this.color = '',
    this.notes = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'client_id': clientId,
        'name': name,
        'breed': breed,
        'color': color,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
      };

  factory Horse.fromMap(Map<String, dynamic> map) => Horse(
        id: map['id'] as int?,
        clientId: map['client_id'] as int,
        name: (map['name'] as String?) ?? '',
        breed: (map['breed'] as String?) ?? '',
        color: (map['color'] as String?) ?? '',
        notes: (map['notes'] as String?) ?? '',
        createdAt: map['created_at'] != null
            ? DateTime.parse(map['created_at'] as String)
            : null,
      );
}

class Visit {
  final int? id;
  final int clientId;
  final String clientName;
  final DateTime dateTime;
  final String notes;
  final bool paid;
  final DateTime createdAt;

  Visit({
    this.id,
    required this.clientId,
    required this.clientName,
    required this.dateTime,
    required this.notes,
    required this.paid,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isPast => dateTime.isBefore(DateTime.now());
  bool get isToday =>
      dateTime.year == DateTime.now().year &&
      dateTime.month == DateTime.now().month &&
      dateTime.day == DateTime.now().day;
  bool get isUpcoming => dateTime.isAfter(DateTime.now());

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'client_id': clientId,
        'datetime': dateTime.toIso8601String(),
        'notes': notes,
        'paid': paid ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      };

  factory Visit.fromMap(Map<String, dynamic> map) {
    final first = (map['first_name'] as String?) ?? '';
    final last = (map['last_name'] as String?) ?? '';
    final name = '$first $last'.trim();
    return Visit(
      id: map['id'] as int?,
      clientId: map['client_id'] as int,
      clientName: name.isEmpty ? 'Unnamed Client' : name,
      dateTime: DateTime.parse(map['datetime'] as String),
      notes: (map['notes'] as String?) ?? '',
      paid: (map['paid'] as int?) == 1,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }
}

class ServiceLine {
  final int? id;
  final int visitId;
  final int? horseId;
  final String horseName;
  final String description;
  final double price;
  final DateTime createdAt;

  ServiceLine({
    this.id,
    required this.visitId,
    this.horseId,
    required this.horseName,
    required this.description,
    required this.price,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'visit_id': visitId,
        'horse_id': horseId,
        'description': description,
        'price': price,
        'created_at': createdAt.toIso8601String(),
      };

  factory ServiceLine.fromMap(Map<String, dynamic> map) => ServiceLine(
        id: map['id'] as int?,
        visitId: map['visit_id'] as int,
        horseId: map['horse_id'] as int?,
        horseName: (map['horse_name'] as String?) ?? 'General',
        description: (map['description'] as String?) ?? '',
        price: (map['price'] as num).toDouble(),
        createdAt: map['created_at'] != null
            ? DateTime.parse(map['created_at'] as String)
            : null,
      );
}

class VisitPhoto {
  final int? id;
  final int visitId;
  final int? horseId;
  final String path;
  final String caption;
  final bool includeOnInvoice;
  final DateTime createdAt;

  VisitPhoto({
    this.id,
    required this.visitId,
    this.horseId,
    required this.path,
    required this.caption,
    required this.includeOnInvoice,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'visit_id': visitId,
        'horse_id': horseId,
        'path': path,
        'caption': caption,
        'include_on_invoice': includeOnInvoice ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      };

  factory VisitPhoto.fromMap(Map<String, dynamic> map) => VisitPhoto(
        id: map['id'] as int?,
        visitId: map['visit_id'] as int,
        horseId: map['horse_id'] as int?,
        path: (map['path'] as String?) ?? '',
        caption: (map['caption'] as String?) ?? '',
        includeOnInvoice: (map['include_on_invoice'] as int?) == 1,
        createdAt: map['created_at'] != null
            ? DateTime.parse(map['created_at'] as String)
            : null,
      );
}
