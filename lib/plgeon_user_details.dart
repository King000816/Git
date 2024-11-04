// plgeon_user_details.dart
class PlgeonUserDetails {
  final String name;        // 사용자 이름
  final String email;       // 이메일
  final String childName;   // 아이 이름

  PlgeonUserDetails({
    required this.name,
    required this.email,
    required this.childName,
  });

  factory PlgeonUserDetails.fromFirestore(Map<String, dynamic> data) {
    return PlgeonUserDetails(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      childName: data['childName'] ?? '',
    );
  }
}
