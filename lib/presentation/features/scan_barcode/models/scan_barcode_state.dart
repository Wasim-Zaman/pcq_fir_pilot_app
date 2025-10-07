/// Represents the state of scan barcode screen
class ScanBarcodeState {
  final bool isLoading;
  final String? error;
  final String? scannedCode;
  final ScanMode scanMode;

  const ScanBarcodeState({
    this.isLoading = false,
    this.error,
    this.scannedCode,
    this.scanMode = ScanMode.qrCode,
  });

  ScanBarcodeState copyWith({
    bool? isLoading,
    String? error,
    String? scannedCode,
    ScanMode? scanMode,
  }) {
    return ScanBarcodeState(
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

  factory ScanBarcodeState.fromJson(Map<String, dynamic> json) {
    return ScanBarcodeState(
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
