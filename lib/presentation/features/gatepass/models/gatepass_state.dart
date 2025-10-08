/// Represents the state of scan barcode screen
class GatePassState {
  final bool isLoading;
  final String? error;
  final String? scannedCode;
  final ScanMode scanMode;

  const GatePassState({
    this.isLoading = false,
    this.error,
    this.scannedCode,
    this.scanMode = ScanMode.qrCode,
  });

  GatePassState copyWith({
    bool? isLoading,
    String? error,
    String? scannedCode,
    ScanMode? scanMode,
  }) {
    return GatePassState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      scannedCode: scannedCode ?? this.scannedCode,
      scanMode: scanMode ?? this.scanMode,
    );
  }

  Map<String, dynamic> toJson() => {
    'isLoading': isLoading,
    'error': error,
    'scannedCode': scannedCode,
    'scanMode': scanMode.name,
  };

  factory GatePassState.fromJson(Map<String, dynamic> json) {
    return GatePassState(
      isLoading: json['isLoading'] as bool? ?? false,
      error: json['error'] as String?,
      scannedCode: json['scannedCode'] as String?,
      scanMode: ScanMode.values.firstWhere(
        (mode) => mode.name == json['scanMode'],
        orElse: () => ScanMode.qrCode,
      ),
    );
  }
}

/// Scan mode enum
enum ScanMode { qrCode, manualInput }
