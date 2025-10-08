/// Model for Location (source/destination)
class Location {
  final String id;
  final String code;
  final String name;
  final String address;
  final String type;
  final String contactPerson;
  final String phone;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Location({
    required this.id,
    required this.code,
    required this.name,
    required this.address,
    required this.type,
    required this.contactPerson,
    required this.phone,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      type: json['type'] as String,
      contactPerson: json['contactPerson'] as String,
      phone: json['phone'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'address': address,
      'type': type,
      'contactPerson': contactPerson,
      'phone': phone,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Model for Vehicle
class Vehicle {
  final String id;
  final String plateNumber;
  final String vehicleType;
  final String make;
  final String color;
  final String imageUrl;
  final String ownerCompany;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle({
    required this.id,
    required this.plateNumber,
    required this.vehicleType,
    required this.make,
    required this.color,
    required this.imageUrl,
    required this.ownerCompany,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as String,
      plateNumber: json['plateNumber'] as String,
      vehicleType: json['vehicleType'] as String,
      make: json['make'] as String,
      color: json['color'] as String,
      imageUrl: json['imageUrl'] as String,
      ownerCompany: json['ownerCompany'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plateNumber': plateNumber,
      'vehicleType': vehicleType,
      'make': make,
      'color': color,
      'imageUrl': imageUrl,
      'ownerCompany': ownerCompany,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Model for Driver
class Driver {
  final String id;
  final String name;
  final String licenseNumber;
  final String phone;
  final String photoUrl;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Driver({
    required this.id,
    required this.name,
    required this.licenseNumber,
    required this.phone,
    required this.photoUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] as String,
      name: json['name'] as String,
      licenseNumber: json['licenseNumber'] as String,
      phone: json['phone'] as String,
      photoUrl: json['photoUrl'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'licenseNumber': licenseNumber,
      'phone': phone,
      'photoUrl': photoUrl,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

/// Model for User (prepared by, approved by, scanned by)
class User {
  final String id;
  final String firstName;
  final String lastName;

  User({required this.id, required this.firstName, required this.lastName});

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'firstName': firstName, 'lastName': lastName};
  }
}

/// Model for Gate Pass Item
class GatePassItem {
  final String id;
  final int srNo;
  final String gatePassId;
  final String? itemId;
  final String itemCode;
  final String description;
  final String uom;
  final int quantity;
  final String? remarks;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic item; // Can be null or an item object

  GatePassItem({
    required this.id,
    required this.srNo,
    required this.gatePassId,
    this.itemId,
    required this.itemCode,
    required this.description,
    required this.uom,
    required this.quantity,
    this.remarks,
    required this.createdAt,
    required this.updatedAt,
    this.item,
  });

  factory GatePassItem.fromJson(Map<String, dynamic> json) {
    return GatePassItem(
      id: json['id'] as String,
      srNo: json['srNo'] as int,
      gatePassId: json['gatePassId'] as String,
      itemId: json['itemId'] as String?,
      itemCode: json['itemCode'] as String,
      description: json['description'] as String,
      uom: json['uom'] as String,
      quantity: json['quantity'] as int,
      remarks: json['remarks'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      item: json['item'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'srNo': srNo,
      'gatePassId': gatePassId,
      'itemId': itemId,
      'itemCode': itemCode,
      'description': description,
      'uom': uom,
      'quantity': quantity,
      'remarks': remarks,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'item': item,
    };
  }
}

/// Model for Verification
class Verification {
  final String id;
  final String gatePassId;
  final String? gatePassItemId;
  final String scanType;
  final DateTime scannedAt;
  final bool isVerified;
  final String scannedById;
  final String? notes;
  final User scannedBy;

  Verification({
    required this.id,
    required this.gatePassId,
    this.gatePassItemId,
    required this.scanType,
    required this.scannedAt,
    required this.isVerified,
    required this.scannedById,
    this.notes,
    required this.scannedBy,
  });

  factory Verification.fromJson(Map<String, dynamic> json) {
    return Verification(
      id: json['id'] as String,
      gatePassId: json['gatePassId'] as String,
      gatePassItemId: json['gatePassItemId'] as String?,
      scanType: json['scanType'] as String,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
      isVerified: json['isVerified'] as bool,
      scannedById: json['scannedById'] as String,
      notes: json['notes'] as String?,
      scannedBy: User.fromJson(json['scannedBy'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gatePassId': gatePassId,
      'gatePassItemId': gatePassItemId,
      'scanType': scanType,
      'scannedAt': scannedAt.toIso8601String(),
      'isVerified': isVerified,
      'scannedById': scannedById,
      'notes': notes,
      'scannedBy': scannedBy.toJson(),
    };
  }
}

/// Main Gate Pass Model
class GatePass {
  final String id;
  final String passNumber;
  final String gatePassType;
  final bool returnable;
  final String sourceFromId;
  final String destinationToId;
  final String senderName;
  final String receiverName;
  final String vehicleId;
  final String driverId;
  final DateTime gatePassDate;
  final DateTime validUntil;
  final String status;
  final String preparedById;
  final DateTime preparedDate;
  final String approvedById;
  final DateTime approvedDate;
  final String approvalStatus;
  final String approvalRemarks;
  final DateTime? securityCheckOut;
  final DateTime? securityCheckIn;
  final DateTime? securityReturnOut;
  final DateTime? securityReturnIn;
  final String? remarks;
  final String? returnedRemarks;
  final String? oracleHeaderId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Location sourceFrom;
  final Location destinationTo;
  final Vehicle vehicle;
  final Driver driver;
  final User preparedBy;
  final User approvedBy;
  final List<GatePassItem> items;
  final List<Verification> verifications;

  GatePass({
    required this.id,
    required this.passNumber,
    required this.gatePassType,
    required this.returnable,
    required this.sourceFromId,
    required this.destinationToId,
    required this.senderName,
    required this.receiverName,
    required this.vehicleId,
    required this.driverId,
    required this.gatePassDate,
    required this.validUntil,
    required this.status,
    required this.preparedById,
    required this.preparedDate,
    required this.approvedById,
    required this.approvedDate,
    required this.approvalStatus,
    required this.approvalRemarks,
    this.securityCheckOut,
    this.securityCheckIn,
    this.securityReturnOut,
    this.securityReturnIn,
    this.remarks,
    this.returnedRemarks,
    this.oracleHeaderId,
    required this.createdAt,
    required this.updatedAt,
    required this.sourceFrom,
    required this.destinationTo,
    required this.vehicle,
    required this.driver,
    required this.preparedBy,
    required this.approvedBy,
    required this.items,
    required this.verifications,
  });

  factory GatePass.fromJson(Map<String, dynamic> json) {
    return GatePass(
      id: json['id'] as String,
      passNumber: json['passNumber'] as String,
      gatePassType: json['gatePassType'] as String,
      returnable: json['returnable'] as bool,
      sourceFromId: json['sourceFromId'] as String,
      destinationToId: json['destinationToId'] as String,
      senderName: json['senderName'] as String,
      receiverName: json['receiverName'] as String,
      vehicleId: json['vehicleId'] as String,
      driverId: json['driverId'] as String,
      gatePassDate: DateTime.parse(json['gatePassDate'] as String),
      validUntil: DateTime.parse(json['validUntil'] as String),
      status: json['status'] as String,
      preparedById: json['preparedById'] as String,
      preparedDate: DateTime.parse(json['preparedDate'] as String),
      approvedById: json['approvedById'] as String,
      approvedDate: DateTime.parse(json['approvedDate'] as String),
      approvalStatus: json['approvalStatus'] as String,
      approvalRemarks: json['approvalRemarks'] as String,
      securityCheckOut: json['securityCheckOut'] != null
          ? DateTime.parse(json['securityCheckOut'] as String)
          : null,
      securityCheckIn: json['securityCheckIn'] != null
          ? DateTime.parse(json['securityCheckIn'] as String)
          : null,
      securityReturnOut: json['securityReturnOut'] != null
          ? DateTime.parse(json['securityReturnOut'] as String)
          : null,
      securityReturnIn: json['securityReturnIn'] != null
          ? DateTime.parse(json['securityReturnIn'] as String)
          : null,
      remarks: json['remarks'] as String?,
      returnedRemarks: json['returnedRemarks'] as String?,
      oracleHeaderId: json['oracleHeaderId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      sourceFrom: Location.fromJson(json['sourceFrom'] as Map<String, dynamic>),
      destinationTo: Location.fromJson(
        json['destinationTo'] as Map<String, dynamic>,
      ),
      vehicle: Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
      driver: Driver.fromJson(json['driver'] as Map<String, dynamic>),
      preparedBy: User.fromJson(json['preparedBy'] as Map<String, dynamic>),
      approvedBy: User.fromJson(json['approvedBy'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((item) => GatePassItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      verifications: (json['verifications'] as List<dynamic>)
          .map(
            (verification) =>
                Verification.fromJson(verification as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'passNumber': passNumber,
      'gatePassType': gatePassType,
      'returnable': returnable,
      'sourceFromId': sourceFromId,
      'destinationToId': destinationToId,
      'senderName': senderName,
      'receiverName': receiverName,
      'vehicleId': vehicleId,
      'driverId': driverId,
      'gatePassDate': gatePassDate.toIso8601String(),
      'validUntil': validUntil.toIso8601String(),
      'status': status,
      'preparedById': preparedById,
      'preparedDate': preparedDate.toIso8601String(),
      'approvedById': approvedById,
      'approvedDate': approvedDate.toIso8601String(),
      'approvalStatus': approvalStatus,
      'approvalRemarks': approvalRemarks,
      'securityCheckOut': securityCheckOut?.toIso8601String(),
      'securityCheckIn': securityCheckIn?.toIso8601String(),
      'securityReturnOut': securityReturnOut?.toIso8601String(),
      'securityReturnIn': securityReturnIn?.toIso8601String(),
      'remarks': remarks,
      'returnedRemarks': returnedRemarks,
      'oracleHeaderId': oracleHeaderId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sourceFrom': sourceFrom.toJson(),
      'destinationTo': destinationTo.toJson(),
      'vehicle': vehicle.toJson(),
      'driver': driver.toJson(),
      'preparedBy': preparedBy.toJson(),
      'approvedBy': approvedBy.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      'verifications': verifications
          .map((verification) => verification.toJson())
          .toList(),
    };
  }
}

/// Gate Pass Response Model
class GatePassResponse {
  final bool success;
  final String message;
  final GatePass data;

  GatePassResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GatePassResponse.fromJson(Map<String, dynamic> json) {
    return GatePassResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: GatePass.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}
