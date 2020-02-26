class Activity
{
  int serverFunction;
  int activityID;
  int userID;
  String activityDate;
  int activityMeasurement;
  String activityComment;
  String activityLogo;
  String activityPicture;
  int categoryID;

  Activity(this.serverFunction, this.activityID, this.userID, this.activityDate, this.activityMeasurement, this.activityComment, this.activityLogo, this.activityPicture, this.categoryID);
  Activity.whoneedsoverloadinganyway();

  Activity.fromJson(Map<String, dynamic> json):
    serverFunction = json['serverFunction'],
    activityID = json['activityID'],
    userID = json['userID'],
    activityDate = json['activityDate'],
    activityMeasurement = json['activityMeasurement'],
    activityComment = json['activityComment'],
    activityLogo = json['activityLogo'],
    activityPicture = json['activityPicture'],
    categoryID = json['categoryID'];

  String getCategoryString(int categoryID)
  {
    String categoryName;
    switch(categoryID)
    {
      case 1:
        categoryName = "Cycling";
        break;
      case 2:
        categoryName = "Boxing";
        break;       
      case 3:
        categoryName = "Swordfighting";
        break;       
      case 4:
        categoryName = "Drinking";
        break;
      case 5:
        categoryName = "Running";
        break;
      case 6:
        categoryName = "Skiing";
        break;
      case 7:
        categoryName = "Eating";
        break;
      case 8:
        categoryName = "Walking backwards";
        break;
      case 9:
        categoryName = "Not really doing that much";
        break;
      case 10:
        categoryName = "Running out of ideas";
        break;
    }
    return categoryName;
  }
}