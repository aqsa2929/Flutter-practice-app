// Model
// ignore_for_file: camel_case_types

class univeristyModel {
  String countryCode = '';
  String countryName = '';
  String universityName = '';
  String provinceName = '';

  univeristyModel({
    required this.countryName,
    required this.countryCode,
    required this.provinceName,
    required this.universityName,
  });
}
