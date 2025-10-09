/// Model for verified item from gate pass
class VerifiedItem {
  final String id;
  final int srNo;
  final String gatePassId;
  final String? itemId;
  final String itemCode;
  final String description;
  final String uom;
  final int quantity;
  final String remarks;
  final String verificationStatus;
  final int verifiedQuantity;
  final String verificationRemarks;
  final DateTime verifiedAt;
  final String verifiedById;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool hasDiscrepancy;
  final int quantityDifference;

  VerifiedItem({
    required this.id,
    required this.srNo,
    required this.gatePassId,
    this.itemId,
    required this.itemCode,
    required this.description,
    required this.uom,
    required this.quantity,
    required this.remarks,
    required this.verificationStatus,
    required this.verifiedQuantity,
    required this.verificationRemarks,
    required this.verifiedAt,
    required this.verifiedById,
    required this.createdAt,
    required this.updatedAt,
    required this.hasDiscrepancy,
    required this.quantityDifference,
  });

  factory VerifiedItem.fromJson(Map<String, dynamic> json) {
    return VerifiedItem(
      id: json['id'] as String,
      srNo: json['srNo'] as int,
      gatePassId: json['gatePassId'] as String,
      itemId: json['itemId'] as String?,
      itemCode: json['itemCode'] as String,
      description: json['description'] as String,
      uom: json['uom'] as String,
      quantity: json['quantity'] as int,
      remarks: json['remarks'] as String,
      verificationStatus: json['verificationStatus'] as String,
      verifiedQuantity: json['verifiedQuantity'] as int,
      verificationRemarks: json['verificationRemarks'] as String,
      verifiedAt: DateTime.parse(json['verifiedAt'] as String),
      verifiedById: json['verifiedById'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      hasDiscrepancy: json['hasDiscrepancy'] as bool,
      quantityDifference: json['quantityDifference'] as int,
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
      'verificationStatus': verificationStatus,
      'verifiedQuantity': verifiedQuantity,
      'verificationRemarks': verificationRemarks,
      'verifiedAt': verifiedAt.toIso8601String(),
      'verifiedById': verifiedById,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'hasDiscrepancy': hasDiscrepancy,
      'quantityDifference': quantityDifference,
    };
  }
}

/// Response model for item verification API
class ItemVerificationResponse {
  final bool success;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final List<VerifiedItem> data;

  ItemVerificationResponse({
    required this.success,
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.data,
  });

  factory ItemVerificationResponse.fromJson(Map<String, dynamic> json) {
    return ItemVerificationResponse(
      success: json['success'] as bool,
      currentPage: json['currentPage'] as int,
      pageSize: json['pageSize'] as int,
      totalItems: json['totalItems'] as int,
      totalPages: json['totalPages'] as int,
      data: (json['data'] as List<dynamic>)
          .map((item) => VerifiedItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'currentPage': currentPage,
      'pageSize': pageSize,
      'totalItems': totalItems,
      'totalPages': totalPages,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
