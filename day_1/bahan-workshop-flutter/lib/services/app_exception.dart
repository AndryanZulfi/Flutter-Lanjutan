import 'package:dio/dio.dart';

class AppException implements Exception {

  final String message;

  AppException(this.message);

  factory AppException.fromDioError(DioException e) {
    String msg;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        msg = "Koneksi terlalu lama, periksa internet Anda.";
        break;
      case DioExceptionType.sendTimeout:
        msg = "Gagal mengirim data ke server.";
        break;
      case DioExceptionType.receiveTimeout:
        msg = "Server terlalu lama merespon.";
        break;
      case DioExceptionType.badResponse:
        msg = "Server error: ${e.response?.statusCode}";
        break;
      case DioExceptionType.cancel:
        msg = "Permintaan dibatalkan.";
        break;
      case DioExceptionType.badCertificate:
        msg = "Sertifikat server tidak valid.";
        break;
      case DioExceptionType.connectionError:
        msg = "Tidak ada internet atau server tidak ditemukan.";
        break;
      default:
        msg = "Terjadi kesalahan yang tidak diketahui.";
    }

    return AppException(msg);
  }

  @override
  String toString() => message;
}
