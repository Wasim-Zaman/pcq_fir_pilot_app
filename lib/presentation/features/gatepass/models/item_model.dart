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
      id: (json['id'] as String?) ?? '',
      srNo: (json['srNo'] as int?) ?? 0,
      gatePassId: (json['gatePassId'] as String?) ?? '',
      itemId: json['itemId'] as String?,
      itemCode: (json['itemCode'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      uom: (json['uom'] as String?) ?? '',
      quantity: (json['quantity'] as int?) ?? 0,
      remarks: (json['remarks'] as String?) ?? '',
      verificationStatus: (json['verificationStatus'] as String?) ?? '',
      verifiedQuantity: (json['verifiedQuantity'] as int?) ?? 0,
      verificationRemarks: (json['verificationRemarks'] as String?) ?? '',
      verifiedAt: json['verifiedAt'] != null
          ? DateTime.parse(json['verifiedAt'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0),
      verifiedById: (json['verifiedById'] as String?) ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0),
      hasDiscrepancy: (json['hasDiscrepancy'] as bool?) ?? false,
      quantityDifference: (json['quantityDifference'] as int?) ?? 0,
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
      success: (json['success'] as bool?) ?? false,
      currentPage: (json['currentPage'] as int?) ?? 0,
      pageSize: (json['pageSize'] as int?) ?? 0,
      totalItems: (json['totalItems'] as int?) ?? 0,
      totalPages: (json['totalPages'] as int?) ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
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

/// Model for verification summary
class VerificationSummary {
  final int totalItems;
  final int pendingItems;
  final int verifiedItems;
  final int unverifiedItems;
  final bool allItemsProcessed;
  final String overallStatus;

  VerificationSummary({
    required this.totalItems,
    required this.pendingItems,
    required this.verifiedItems,
    required this.unverifiedItems,
    required this.allItemsProcessed,
    required this.overallStatus,
  });

  factory VerificationSummary.fromJson(Map<String, dynamic> json) {
    return VerificationSummary(
      totalItems: (json['totalItems'] as int?) ?? 0,
      pendingItems: (json['pendingItems'] as int?) ?? 0,
      verifiedItems: (json['verifiedItems'] as int?) ?? 0,
      unverifiedItems: (json['unverifiedItems'] as int?) ?? 0,
      allItemsProcessed: (json['allItemsProcessed'] as bool?) ?? false,
      overallStatus: (json['overallStatus'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      'pendingItems': pendingItems,
      'verifiedItems': verifiedItems,
      'unverifiedItems': unverifiedItems,
      'allItemsProcessed': allItemsProcessed,
      'overallStatus': overallStatus,
    };
  }
}

/// Model for verified by user
class VerifiedBy {
  final String id;
  final String firstName;
  final String lastName;

  VerifiedBy({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory VerifiedBy.fromJson(Map<String, dynamic> json) {
    return VerifiedBy(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'firstName': firstName, 'lastName': lastName};
  }

  String get fullName => '$firstName $lastName';
}

/// Model for item verification result
class ItemVerificationResult {
  final VerifiedItem item;
  final VerificationSummary verificationSummary;

  ItemVerificationResult({
    required this.item,
    required this.verificationSummary,
  });

  factory ItemVerificationResult.fromJson(Map<String, dynamic> json) {
    return ItemVerificationResult(
      item: VerifiedItem.fromJson(
        json['item'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      verificationSummary: VerificationSummary.fromJson(
        json['verificationSummary'] as Map<String, dynamic>? ??
            <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': item.toJson(),
      'verificationSummary': verificationSummary.toJson(),
    };
  }
}

/// Response model for verify item API
class VerifyItemResponse {
  final bool success;
  final String message;
  final VerificationResponseData data;

  VerifyItemResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory VerifyItemResponse.fromJson(Map<String, dynamic> json) {
    return VerifyItemResponse(
      success: (json['success'] as bool?) ?? false,
      message: (json['message'] as String?) ?? '',
      data: VerificationResponseData.fromJson(
        json['data'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

/// Model to correctly map the nested 'data' object in the response.
class VerificationResponseData {
  final VerifiedItem verification;
  final VerificationSummary progress;

  VerificationResponseData({
    required this.verification,
    required this.progress,
  });

  factory VerificationResponseData.fromJson(Map<String, dynamic> json) {
    return VerificationResponseData(
      // The JSON has 'verification' and 'progress' fields at the same level.
      verification: VerifiedItem.fromJson(
        json['verification'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      progress: VerificationSummary.fromJson(
        json['progress'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'verification': verification.toJson(),
      'progress': progress.toJson(),
    };
  }
}
