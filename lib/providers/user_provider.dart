import 'package:flutter/material.dart';
import 'package:fytness_system/models/user.dart';
import 'package:fytness_system/models/membership_package.dart';
import 'package:fytness_system/services/membership_package_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  MembershipPackage? _membershipPackage;

  User? get user => _user;
  MembershipPackage? get membershipPackage => _membershipPackage;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void setMembershipPackage(MembershipPackage membershipPackage) {
    _membershipPackage = membershipPackage;
    notifyListeners();
  }

  Future<void> fetchMembershipPackage(int membershipPackageId) async {
    _membershipPackage = await fetchMembershipPackageById(membershipPackageId);
    notifyListeners();
  }

}
