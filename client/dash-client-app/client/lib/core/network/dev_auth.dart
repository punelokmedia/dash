import 'package:flutter/foundation.dart';

const devAuthEnabled = kDebugMode && bool.fromEnvironment('DEV_AUTH');
const apiBaseUrl = String.fromEnvironment('API_BASE_URL',
    defaultValue: 'http://localhost:5000/');
