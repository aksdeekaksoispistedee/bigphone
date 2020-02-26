class ActivityCategory
{
  int categoryID;
  String categoryName;

  ActivityCategory(this.categoryID, this.categoryName);

  ActivityCategory.fromJson(Map<String, dynamic> json):
    categoryID = json['categoryId'],
    categoryName = json['categoryName'];
}