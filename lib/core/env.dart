import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

///AppSettings Environments
String appType = '';
String inventoryType = '';
String currency = 'Rs';
String currencyName = 'Pakistani Rupee';
String viewType = '';
String? logo = '';
String googleApiToken = 'AIzaSyDZnazv4f9z_aXrh9n67cWThyYXuH2Otac';

//Map for translations
Map<String, dynamic>? translations = {};

//Map to collect already collected information for adding a machine
Map<String, dynamic> carData = {};

//Map for features car
Map<String, dynamic> carFeatures = {};

//List for filter
Map<String, dynamic> filteredListForSearch = {};

//Local Storage
late SharedPreferences preferences;

//ImagePicker
final ImagePicker picker = ImagePicker();
