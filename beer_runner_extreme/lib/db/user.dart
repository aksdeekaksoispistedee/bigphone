class User
{
  int userID;
  int serverFunction;
  String accountName;
  String accountPassword;
  String usersName;
  String userInformation;
  int userHeight;
  int userWeight;
  String userBirth;

  User();

  User.fromJson(Map<String, dynamic> json):
    userID = json['userID'],
    accountName = json['accountName'],
    usersName = json['usersName'],
    userInformation = json['userInformation'],
    userHeight = json['userHeight'],
    userWeight = json['userWeight'],
    userBirth= json['userBirth'];

}