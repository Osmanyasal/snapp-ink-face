class Urls {
  static const String kBaseUrl = 'http://192.168.1.23:18080';
  static const String registerApi = '/register?id=';
  static const String registerTargetApi = '/register/target?id=';
  static const String applyFilter = '/filters/';
  static const String terminateSession = '/terminate-session?id=';
  static const String apiKey = '';  // this will be sent in http header NOT AS A QUERY PARAM
}

/*  TODO
***** Rules *****

* Call REGISTER HTTP POST services ONLY when you select a photo from the library !
* Call /register?id= if you select at the beginning, call /register/target?id= if you select from the filters (by selecting add icon)

* Call filter services to apply a filter onto images registered. Use http get http://192.168.1.23:18080/filters/<file_name>?id=
* <filter_name> is the file name of the images under /assets/images/filters/ or /assets/images/ai_filters/
* if file name contains '-' character, replace that in the url to '/'
    * so if file name is vintage-old1n.png, url: http get http://192.168.1.23:18080/filters/vintage/old1?id=
    * a file name grayscale would be normal like url: http get http://192.168.1.23:18080/filters/grayscale?id=

* call terminate-session service when app is closed.

* In all requests, send "id" as a query param!
* In all requests, send "apiKey" as a header param!
* Image is sent as-is in binary "we used postman to test out api and selected image under /body/binary/

***** Example Flows *****

---- Usual Flow Example ----
* user selects a photo from the galary or shoot one -> call http post http://192.168.1.23:18080/register?id= service by placing "id" as query param and apiKey as http header param.
* user selects a filter named sketch-5.jpg from the /images/filters/ 
* upon click "apply sketch" -> call http get http://192.168.1.23:18080/filters/sketch/5?id= service by placing "id" as query param and apiKey as http header param.


---- Add Photo Example ----
* user selects a photo from the galary or shoot one -> call http post http://192.168.1.23:18080/register?id= service by placing "id" as query param and apiKey as http header param.
* user selects "add photo" in ai filters -> call http post http://192.168.1.23:18080/register/target?id= service by placing "id" as query param and apiKey as http header param.
* upon click "apply custom" -> call http get http://192.168.1.23:18080/filters/face-swap?id= service by placing "id" as query param and apiKey as http header param.

*/

