import 'dart:io';
import 'package:beer_runner_extreme/db/activity.dart';
import 'package:beer_runner_extreme/db/activityCategory.dart';
import 'package:beer_runner_extreme/db/password.dart';
import 'package:beer_runner_extreme/db/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Jsonfucker
{
  static const _serviceUrl = "HERETHREBELOCALIP";
  static final _headers = {'Content-Type': 'application/json'}; //  IF CHANGED, EDIT NEW LENGHT TO SERVER OR ELSE ENJOY LE FUCKED.
  static final _leFrenchHeader = {'Content-Type': 'image/png'};

  Future<bool> addActivity(int userID, Activity newActivity) async
  {
    bool serverResponse;
    try
    {
      String json = _activityAddJson(userID, newActivity);
      await http.post(_serviceUrl, headers: _headers, body: json).then((http.Response response)
      {
        if(response.statusCode == 200) serverResponse = true;
        else serverResponse = false;
      });
    }
    catch(e)
    {
      serverResponse = false;
    }
    return serverResponse;
  }

  Future<bool> changePassword(Password password) async
  {
    bool serverResponse;
    try
    {
      String json = _passwordJson(password, 2);
      await http.post(_serviceUrl, headers: _headers, body: json).then((http.Response response)
      {
        if(response.statusCode == 200) serverResponse = true;
        else serverResponse = false;
      });
    }
    catch(e)
    {
      serverResponse = false;
    }
    return serverResponse;
  }

  Future<int> createUser(User newUser) async
  {
    int serverResponse;
    try
    {
      String json = _registrationJson(newUser);
      await http.post(_serviceUrl, headers: _headers, body: json).then((http.Response response)
      {
        if(response.statusCode == 200) serverResponse = 0;
        else if(response.statusCode == 409) serverResponse = 2;
        else serverResponse = 1;
      });
    }
    catch(e)
    {
      serverResponse = 1;
    }
    return serverResponse;
  }

  Future<bool> deleteActivity(int activityID) async
  {
    bool serverResponse;
    try
    {
      String json = _deleteActivityJson(activityID);
      await http.post(_serviceUrl, headers: _headers, body: json).then((http.Response response)
      {
        if(response.statusCode == 200) serverResponse = true;
        else serverResponse = false;
      });
    }
    catch(e)
    {
      serverResponse = false;
    }
    return serverResponse;
  }

  Future<List<int>> downloadImage(int activityID) async
  {
    List<int> serverResponse;
    try
    {
      String lenghtFiller = "";
      for(int i = 0; i < 18-activityID.toString().length; i++)
      {
        lenghtFiller += "-";
      }
      String meryl = activityID.toString() + lenghtFiller + " 11 ";
      await http.post(_serviceUrl, headers: _headers, body: meryl).then((http.Response response)
        {
          if(response.statusCode == 200)
          {
            serverResponse = response.bodyBytes;
            return serverResponse;
          }
          else return serverResponse;
      });
    }
    catch(e)
    {
      //ulu
    }
    return serverResponse;
  }

  Future<bool> editActivity(int activityID, Activity editedActivity) async
  {
    bool serverResponse;
    try
    {
      String json = _editActivityJson(activityID, editedActivity);
      await http.post(_serviceUrl, headers: _headers, body: json).then((http.Response response)
      {
        if(response.statusCode == 200) serverResponse = true;
        else serverResponse = false;
      });
    }
    catch(e)
    {
      serverResponse = false;
    }
    return serverResponse;
  }

  Future<bool> editUserInformation(User information) async
  {
    bool serverResponse;
    try
    {
      String json = _informationJson(information);
      await http.post(_serviceUrl, headers: _headers, body: json).then((http.Response response)
        {
          if(response.statusCode == 200) serverResponse = true;
          else serverResponse = false;
        });
    }
    catch(e)
    {
      serverResponse = false;
    }
    return serverResponse;
  }

  Future<List<Activity>> getActivities(int userID) async
  {
    String serverResponse;
    List<Activity> activityList = new List<Activity>();
    List<String> activityStrings = new List<String>();
    try
    {
      String json = _activityQueryJson(userID);
      await http.post(_serviceUrl, headers: _headers, body: json).then((http.Response response)
        {
          if(response.statusCode == 200)
          {
            serverResponse = response.body;
            String individualActivity = "";
            int startIndex = 0;
            int endIndex;
            bool terminate = false;
            do 
            {
              endIndex = serverResponse.indexOf("}");
              individualActivity = serverResponse.substring(startIndex, endIndex+1);
              activityStrings.add(individualActivity);
              if(endIndex+1 < serverResponse.length)
              {
                serverResponse = serverResponse.substring(endIndex+1, serverResponse.length);
              } 
              else terminate = true;
            } while (!terminate);
            for (int i = 0; i < activityStrings.length; i++) 
            {
              Map treasurechart = jsonDecode(activityStrings[i]);
              Activity thing = Activity.fromJson(treasurechart);
              activityList.add(thing);
            }
          }
        });
    }
    catch(e)
    {
      //asdaa 
    }
    return activityList;
  }

  Future<List<ActivityCategory>> getActivityCategories() async
  {
    String serverResponse;
    List<ActivityCategory> categoryList = new List<ActivityCategory>();
    List<String> categoryStrings = new List<String>();
    try
    {
      String json = _categoryQueryJson();
      await http.post(_serviceUrl, headers: _headers, body: json).then((http.Response response)
      {
        serverResponse = response.body;
        String individualCategory = "";
        int startIndex = 0;
        int endIndex;
        bool terminate = false;
        do 
        {
          endIndex = serverResponse.indexOf("}");
          individualCategory = serverResponse.substring(startIndex, endIndex+1);
          categoryStrings.add(individualCategory);
          if(endIndex+1 < serverResponse.length)
          {
            serverResponse = serverResponse.substring(endIndex+1, serverResponse.length);
          } 
          else terminate = true;
        } while (!terminate);
        for (int i = 0; i < categoryStrings.length; i++) 
        {
          Map treasurechart = jsonDecode(categoryStrings[i]);
          ActivityCategory thing = ActivityCategory.fromJson(treasurechart);
          categoryList.add(thing);
        }
      });
    }
    catch(e)
    {
      ActivityCategory asd = new ActivityCategory(0, e.toString());
      categoryList.add(asd);
    }
    return categoryList;
  } 

  Future<User> logInUser(User logIn) async
  {
    String serverResponse;
    User login = new User();
    try
    {
      String json = _logInJson(logIn);
      await http.post(_serviceUrl, headers: _headers, body: json).then((http.Response response)
        {
          if(response.statusCode == 200)
          {
            serverResponse = response.body;
            Map treasurechart = jsonDecode(serverResponse);
            login = User.fromJson(treasurechart);
          }
          else
          {
            //asdaa?
          }
        });
    }
    catch(e)
    {
      //asdaa :)
    }
    return login;
  }

  Future<bool> uploadImage(int activityID, File image) async
  {
    bool serverResponse;
    String lenghtFiller = "";
    for(int i = 0; i < 18-activityID.toString().length; i++)
    {
      lenghtFiller += "-";
    }
    List<int> imageBytes = image.readAsBytesSync();
    String meryl = activityID.toString() + lenghtFiller + " 10 " + base64Encode(imageBytes);
    try
    {
      await http.post(_serviceUrl, headers: _leFrenchHeader, body: meryl).then((http.Response response)
        {
          if(response.statusCode == 200) serverResponse = true;
          else serverResponse = false;
        });
    }
    catch(e)
    {
      serverResponse = false;
    }
    return serverResponse;
  }

  Future<bool> verifyPassword(Password password) async
  {
    bool serverResponse;
    try
    {
      String json = _passwordJson(password, 9);
      await http.post(_serviceUrl, headers: _headers, body: json).then((http.Response response)
      {
        if(response.statusCode == 200) serverResponse = true;
        else serverResponse = false;
      });
    }
    catch(e)
    {
      serverResponse = false;
    }
    return serverResponse;
  }

/*
* SERVERFUNCTION MUST ALWAYS BE MAPPED *AND* BE THE 1ST MAPPED DATA* - ELSE LE FUCKED.
* *APART FROM THE CASES WHEN THINGS ARE DONE DIFFERENTLY LOL. FUNNY, AIN'T IT?
*/

  String _activityAddJson(int userID, Activity newActivity)
  {
    var mapData = new Map();
    mapData['serverFunction'] = 4;
    mapData['activityID'] = 0;
    mapData['UserID'] = userID;
    mapData['ActivityDate'] = newActivity.activityDate;
    mapData['ActivityMeasurement'] = newActivity.activityMeasurement;
    mapData['ActivityComment'] = newActivity.activityComment;
    mapData['ActivityLogo'] = newActivity.activityLogo;
    mapData['ActivityPicture'] = "0";
    mapData['CategoryID'] = newActivity.categoryID;
    String json = jsonEncode(mapData);
    return json;
  }

  String _activityQueryJson(int userID)
  {
    var mapData = new Map();
    mapData['serverFunction'] = 3;
    mapData['UserID'] = userID;
    String json = jsonEncode(mapData);
    return json;
  }

  String _categoryQueryJson()
  {
    var mapData = new Map();
    mapData['serverFunction'] = 8;
    String json = jsonEncode(mapData);
    return json;
  }

  String _deleteActivityJson(int activityID)
  {
    var mapData = new Map();
    mapData['serverFunction'] = 6;
    mapData['ActivityID'] = activityID; 
    String json = jsonEncode(mapData);
    return json;
  }

  String _editActivityJson(int activityID, Activity editedActivity)
  {
    var mapData = new Map();
    mapData['serverFunction'] = 5;
    mapData['activityID'] = activityID;
    mapData['UserID'] = editedActivity.userID;
    mapData['ActivityDate'] = editedActivity.activityDate;
    mapData['ActivityMeasurement'] = editedActivity.activityMeasurement;
    mapData['ActivityComment'] = editedActivity.activityComment;
    mapData['ActivityLogo'] = editedActivity.activityLogo;
    mapData['ActivityPicture'] = "-1";
    mapData['CategoryID'] = editedActivity.categoryID;
    String json = jsonEncode(mapData);
    return json;
  }

  String _informationJson(User informationUser)
  {
    var mapData = new Map();
    mapData['serverFunction'] = 7;
    mapData['UserID'] = informationUser.userID;
    mapData['UsersName'] = informationUser.usersName;
    mapData['UserHeight'] = informationUser.userHeight;
    mapData['UserWeight'] = informationUser.userWeight;
    mapData['UserBirth'] = informationUser.userBirth;
    String json = jsonEncode(mapData);
    return json;
  }

  String _passwordJson(Password password, int serverFunction)
  {
    var mapData = new Map();
    mapData['serverFunction'] = serverFunction;
    mapData['UserID'] = password.userID;
    if(serverFunction == 2) mapData['AccountPassword'] = password.newPassword;
    else if(serverFunction == 9) mapData['AccountPassword'] = password.oldPassword;
    String json = jsonEncode(mapData);
    return json;
  }

  String _logInJson(User logInUser)
  {
    var mapData = new Map();
    mapData['serverFunction'] = 1;
    mapData['AccountName'] = logInUser.accountName;
    mapData['AccountPassword'] = logInUser.accountPassword;
    String json = jsonEncode(mapData);
    return json;
  }

  String _registrationJson(User newUser)
  {
    var mapData = new Map();
    mapData['serverFunction'] = 0;
    mapData['AccountName'] = newUser.accountName;
    mapData['AccountPassword'] = newUser.accountPassword;
    mapData['UsersName'] = newUser.usersName;
    mapData['UserInformation'] = newUser.userInformation;
    String json = jsonEncode(mapData);
    return json;
  }
}