// ignore_for_file: file_names

class GstinModel {
  final String gstin;
  final String message;

  GstinModel({
    required this.gstin,
    required this.message,
  });

  // API response: { "success": true, "data": { "gstIn": "...", "message": "..." } }
  factory GstinModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return GstinModel(
      gstin:   data['gstIn']   as String? ?? '',
      message: data['message'] as String? ?? 'GSTIN added successfully',
    );
  }
}