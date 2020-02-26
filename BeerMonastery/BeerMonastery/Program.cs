/*
 * Oskari Sihvonen
 * Savonia-AMK ETX13SP
 * Mobiiliohjelmoinnin jatkokurssi
 * 14/01/2020
 * */

using System;
using System.Net;
using System.Data.SqlClient;
using System.Collections;
using System.IO;
using Newtonsoft.Json;
using System.Text;
using System.Collections.Generic;

namespace BeerMonastery
{
    class Program
    {
        static void Main(string[] args)
        {
            SqlCommand command;
            string clientInput;
            string activityID;

            bool terminate = false;
            string connectionString = @"Server=(localdb)\mssqllocaldb;Initial Catalog=makkara;Integrated Security=True";
            SqlConnection connection = new SqlConnection(connectionString);
            int control = 99;
            HttpListener server = new HttpListener();
            server.Prefixes.Add("HERETHEREBELOCALHOST"); //le localhost, get your own

            server.Start();
            Console.WriteLine("Online and listening.");
            while (!terminate)
            {
                HttpListenerContext context = server.GetContext();
                HttpListenerRequest request = context.Request;
                using (StreamReader reader = new StreamReader(request.InputStream, request.ContentEncoding))
                {
                    clientInput = reader.ReadToEnd();
                }
                //Console.WriteLine(clientInput.ToString());
                //Console.WriteLine(clientInput.Substring(18,1));
                if(clientInput[0].Equals('{'))
                    int.TryParse(clientInput.Substring(18, 1), out control);
                else
                    int.TryParse(clientInput.Substring(clientInput.IndexOf(" ")+1, 2), out control);
                switch (control)
                {
                    case 0: // User registration, unique usernames.
                        connection.Open();
                        try
                        {
                            User user = JsonConvert.DeserializeObject<User>(clientInput);
                            command = new SqlCommand("select * from Users where AccountName = '" + user.accountName + "'", connection);
                            HttpListenerResponse response = context.Response;
                            if (command.ExecuteReader().HasRows == true)
                            {
                                Console.WriteLine("Registration failure: Username unavailable.");
                                response.StatusCode = (int)HttpStatusCode.Conflict;
                                response.Close();
                            }
                            else
                            {
                                connection.Close();
                                connection.Open();
                                command = new SqlCommand("insert into Users values(" +
                                    "'" + user.accountName
                                    + "', '" + user.accountPassword
                                    + "', '" + user.usersName
                                    + "', '" + user.userInformation
                                    + "', " + 0
                                    + ", " + 0
                                    + ", '" + null
                                    + "')", connection);
                                if(command.ExecuteNonQuery() == 1)
                                {
                                    Console.WriteLine("Account " + user.accountName + " created.");
                                    response.StatusCode = (int)HttpStatusCode.OK;
                                    response.Close();
                                }
                                else
                                {
                                    Console.WriteLine("Failure when creating an account.");
                                    response.StatusCode = (int)HttpStatusCode.Forbidden;
                                    response.Close();
                                }
                            }
                        }
                        catch(Exception e)
                        {
                            Console.WriteLine("DB FUNCTION 0 ERROR: " + e);
                        }
                        finally
                        {
                            connection.Close();
                        }
                        break;
                    case 1: // User login.
                        connection.Open();
                        try
                        {
                            User user = JsonConvert.DeserializeObject<User>(clientInput);
                            command = new SqlCommand("select * from Users where AccountName = '" + user.accountName + "' and AccountPassword = '" + user.accountPassword + "'", connection);
                            HttpListenerResponse response = context.Response;
                            Stream output = response.OutputStream;
                            User login = new User();
                            using (SqlDataReader reader = command.ExecuteReader())
                            {
                                if (reader.HasRows)
                                {
                                    while (reader.Read())
                                    {
                                        login.userID = reader.GetInt32(0);
                                        login.accountName = reader.GetString(1);
                                        login.usersName = reader.GetString(3);
                                        login.userInformation = reader.GetString(4);
                                        login.userHeight = reader.GetInt32(5);
                                        login.userWeight = reader.GetInt32(6);
                                        login.userBirth = reader.GetDateTime(7).ToString();
                                    }
                                    string master = JsonConvert.SerializeObject(login);
                                    byte[] bytes = Encoding.UTF8.GetBytes(master);
                                    response.ContentLength64 = bytes.Length;
                                    output.Write(bytes, 0, bytes.Length);
                                    output.Close();
                                    response.StatusCode = (int)HttpStatusCode.OK;
                                    response.Close();
                                }
                                else
                                {
                                    output.Close();
                                    response.StatusCode = (int)HttpStatusCode.NoContent;
                                    response.Close();
                                }
                            }
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine("DB FUNCTION 1 ERROR: " + e);
                        }
                        finally
                        {
                            connection.Close();
                        }
                        break;
                    case 2: // Password editing for existing users.
                        connection.Open();
                        try
                        {
                            User user = JsonConvert.DeserializeObject<User>(clientInput);
                            HttpListenerResponse response = context.Response;
                            command = new SqlCommand("update Users set AccountPassword = '" + user.accountPassword + "' where UserID = " + user.userID + ";", connection);
                            if(command.ExecuteNonQuery() == 1)
                            {
                                Console.WriteLine("Password changed for user no. " + user.userID.ToString());
                                response.StatusCode = (int)HttpStatusCode.OK;
                                response.Close();
                            }
                            else
                            {
                                Console.WriteLine("Error with password change.");
                                response.StatusCode = (int)HttpStatusCode.Forbidden;
                                response.Close();
                            } 
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine("DB FUNCTION 2 ERROR: " + e);
                        }
                        finally
                        {
                            connection.Close();
                        }
                        break;
                    case 3: // Retrieving existing activity records for client.
                        connection.Open();
                        try
                        {
                            ActivityQuery query = JsonConvert.DeserializeObject<ActivityQuery>(clientInput);
                            HttpListenerResponse response = context.Response;
                            Stream output = response.OutputStream;
                            bool hasActivities = false;
                            List<Activity> activityList = new List<Activity>();
                            command = new SqlCommand("select * from Activity where UserID = " + query.userID + ";", connection);
                            using (SqlDataReader reader = command.ExecuteReader())
                            {
                                if(reader.HasRows)
                                {
                                    hasActivities = true;
                                    while (reader.Read())
                                    {
                                        activityList.Add(new Activity
                                        {
                                            activityID = reader.GetInt32(0),
                                            userID = reader.GetInt32(1),
                                            activityDate = reader.GetDateTime(2).ToString(),
                                            activityMeasurement = reader.GetInt32(3),
                                            activityComment = reader.GetString(4),
                                            activityLogo = reader.GetString(5),
                                            activityPicture = reader.GetString(6),
                                            categoryID = reader.GetInt32(7)
                                        });
                                    }
                                }
                            }
                            if(hasActivities)
                            {
                                string master = "";
                                foreach (Activity activity in activityList)
                                {
                                    master += JsonConvert.SerializeObject(activity);
                                }
                                //Console.WriteLine(master);
                                byte[] bytes = Encoding.UTF8.GetBytes(master);
                                response.ContentLength64 = bytes.Length;
                                output.Write(bytes, 0, bytes.Length);
                                output.Close();
                                response.StatusCode = (int)HttpStatusCode.OK;
                                response.Close();
                            }
                            else
                            {
                                output.Close();
                                response.StatusCode = (int)HttpStatusCode.NoContent;
                                response.Close();
                            }
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine("DB FUNCTION 3 ERROR: " + e);
                        }
                        finally
                        {
                            connection.Close();
                        }
                        break;
                    case 4: // Add a new activity record.
                        connection.Open();
                        try
                        {
                            Activity activity = JsonConvert.DeserializeObject<Activity>(clientInput);
                            HttpListenerResponse response = context.Response;
                            command = new SqlCommand("insert into Activity values ("
                                + activity.userID
                                + ", '" + activity.activityDate
                                + "', " + activity.activityMeasurement
                                + ", '" + activity.activityComment
                                + "', '" + activity.activityLogo
                                + "', '" + activity.activityPicture
                                + "'," + activity.categoryID
                                + ");", connection);
                            if(command.ExecuteNonQuery() == 1)
                            {
                                response.StatusCode = (int)HttpStatusCode.OK;
                                response.Close();
                            }
                            else
                            {
                                response.StatusCode = (int)HttpStatusCode.Forbidden;
                                response.Close();
                            }
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine("DB FUNCTION 4 ERROR: " + e);
                        }
                        finally
                        {
                            connection.Close();
                        }
                        break;
                    case 5: // Modify an existing activity record.
                        connection.Open();
                        try
                        {
                            Activity activity = JsonConvert.DeserializeObject<Activity>(clientInput);
                            HttpListenerResponse response = context.Response;
                            command = new SqlCommand("update Activity set " +
                                "ActivityDate = '" + activity.activityDate + "', " +
                                "ActivityMeasurement = " + activity.activityMeasurement + ", " +
                                "ActivityComment = '" + activity.activityComment + "', " +
                                "ActivityLogo = '" + activity.activityLogo + "', " +
                                "ActivityPicture = '" + activity.activityPicture + "', " +
                                "CategoryID = " + activity.categoryID + " where " +
                                "ActivityID = " + activity.activityID + ";", connection);
                            if(command.ExecuteNonQuery() == 1)
                            {
                                Console.WriteLine("Activity no. " + activity.activityID + " edited.");
                                response.StatusCode = (int)HttpStatusCode.OK;
                                response.Close();
                            }
                            else
                            {
                                Console.WriteLine("Activity edit failed.");
                                response.StatusCode = (int)HttpStatusCode.Forbidden;
                                response.Close();
                            }
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine("DB FUNCTION 5 ERROR: " + e);
                        }
                        finally
                        {
                            connection.Close();
                        }
                        break;
                    case 6: // Delete an existing activity record.
                        connection.Open();
                        try
                        {
                            ActivityDeletion deletion = JsonConvert.DeserializeObject<ActivityDeletion>(clientInput);
                            HttpListenerResponse response = context.Response;
                            command = new SqlCommand("delete from Activity where ActivityID = " + deletion.activityID + "", connection);
                            if(command.ExecuteNonQuery() == 1)
                            {
                                Console.WriteLine("Activity no. " + deletion.activityID + " deleted.");
                                response.StatusCode = (int)HttpStatusCode.OK;
                                response.Close();
                            }
                            else
                            {
                                Console.WriteLine("Activity deletion failed.");
                                response.StatusCode = (int)HttpStatusCode.Forbidden;
                                response.Close();
                            }
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine("DB FUNCTION 6 ERROR: " + e);
                        }
                        finally
                        {
                            connection.Close();
                        }
                        break;
                    case 7: // Modify non-password user information.
                        connection.Open();
                        try
                        {
                            User user = JsonConvert.DeserializeObject<User>(clientInput);
                            HttpListenerResponse response = context.Response;
                            command = new SqlCommand("update Users set" +
                                " UsersName = '" + user.usersName + "'," +
                                " UserHeight = " + user.userHeight + "," +
                                " UserWeight = " + user.userWeight + "," +
                                " UserBirth = '" + user.userBirth + "'" +
                                " where UserID = " + user.userID + ";", connection);
                            if (command.ExecuteNonQuery() == 1)
                            {
                                Console.WriteLine("User information edited for user no. " + user.userID.ToString());
                                response.StatusCode = (int)HttpStatusCode.OK;
                                response.Close();
                            }
                            else
                            {
                                Console.WriteLine("User information editing failed.");
                                response.StatusCode = (int)HttpStatusCode.Forbidden;
                                response.Close();
                            }
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine("DB FUNCTION 7 ERROR: " + e);
                        }
                        finally
                        {
                            connection.Close();
                        }
                        break;
                    case 8: // Retrieve activity categories for client.
                        connection.Open();
                        try
                        {
                            HttpListenerResponse response = context.Response;
                            Stream output = response.OutputStream;
                            List<ActivityCategory> categoryList = new List<ActivityCategory>();
                            command = new SqlCommand("select * from ActivityCategories", connection);
                            using (SqlDataReader reader = command.ExecuteReader())
                            {
                                while(reader.Read())
                                {
                                    categoryList.Add(new ActivityCategory
                                    {
                                        categoryId = reader.GetInt32(0),
                                        categoryName = reader.GetString(1)
                                    });
                                }
                            }
                            string master = "";
                            foreach (ActivityCategory category in categoryList)
                            {
                                master += JsonConvert.SerializeObject(category);
                            }
                            //Console.WriteLine(master);
                            byte[] bytes = Encoding.UTF8.GetBytes(master);
                            response.ContentLength64 = bytes.Length;
                            output.Write(bytes, 0, bytes.Length);
                            output.Close();
                            response.StatusCode = (int)HttpStatusCode.OK;
                            response.Close();
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine("DB FUNCTION 8 ERROR: " + e);
                        }
                        finally
                        {
                            connection.Close();
                        }
                        break;
                    case 9: // Verify current password for password change.
                        connection.Open();
                        try
                        {
                            User user = JsonConvert.DeserializeObject<User>(clientInput);
                            command = new SqlCommand("select UserID, AccountPassword from Users where UserID = " + user.userID + " and AccountPassword ='" + user.accountPassword + "'", connection);
                            HttpListenerResponse response = context.Response;
                            if (command.ExecuteReader().HasRows == true)
                            {
                                Console.WriteLine("Password verification for user no. " + user.userID.ToString() + "succeeded.");
                                response.StatusCode = (int)HttpStatusCode.OK;
                                response.Close();
                            }
                            else
                            {
                                Console.WriteLine("Password verification failure.");
                                response.StatusCode = (int)HttpStatusCode.Forbidden;
                                response.Close();
                            }
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine("DB FUNCTION 9 ERROR: " + e);
                        }
                        finally
                        {
                            connection.Close();
                        }
                        break;
                    case 10: // Receive image from a client.
                        connection.Open();
                        try
                        {
                            activityID = clientInput.Substring(0, clientInput.IndexOf("-"));
                            clientInput = clientInput.Remove(0, 22);
                            File.WriteAllBytes(@"./Images/"+ activityID +".png", Convert.FromBase64String(clientInput));
                            command = new SqlCommand("update Activity set ActivityPicture = '" + activityID + ".png' where ActivityID = " + activityID + ";", connection);
                            HttpListenerResponse response = context.Response;
                            if (command.ExecuteNonQuery() == 1)
                            {
                                Console.WriteLine("Added picture to activity " + activityID + ".");
                                response.StatusCode = (int)HttpStatusCode.OK;
                                response.Close();
                            }
                            else
                            {
                                Console.WriteLine("Failure when attaching picture to activity.");
                                response.StatusCode = (int)HttpStatusCode.Forbidden;
                                response.Close();
                            }
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine("DB FUNCTION 10 ERROR: " + e);
                        }
                        finally
                        {
                            connection.Close();
                        }
                        break;
                    case 11: // Send image to a client.
                        connection.Open();
                        try
                        {
                            activityID = clientInput.Substring(0, clientInput.IndexOf("-"));
                            clientInput = clientInput.Remove(0, 22);
                            command = new SqlCommand("select ActivityPicture from Activity where ActivityID = " + activityID + " and ActivityPicture != '0';", connection);
                            HttpListenerResponse response = context.Response;
                            Stream output = response.OutputStream;
                            if (command.ExecuteReader().HasRows == false)
                            {
                                Console.WriteLine("Client requested an inexistent picture.");
                                response.StatusCode = (int)HttpStatusCode.NoContent;
                                response.Close();
                            }
                            else
                            {
                                Console.WriteLine("Client requested a picture from activity " + activityID + ".");
                                byte[] image = File.ReadAllBytes(@"./Images/" + activityID + ".png");
                                response.ContentLength64 = image.Length;
                                output.Write(image, 0, image.Length);
                                output.Close();
                                response.StatusCode = (int)HttpStatusCode.OK;
                                response.Close();
                            }
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine("DB FUNCTION 11 ERROR: " + e);
                        }
                        finally
                        {
                            connection.Close();
                        }
                        break;
                    default: // Terminate server.
                        if (connection.State == System.Data.ConnectionState.Open)
                            connection.Close();
                        terminate = true;
                        server.Stop();
                        break;
                }
            }
        }
    }
}
