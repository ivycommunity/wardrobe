import 'package:logger/logger.dart';

// Global logger instance
final Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0, // Removes method traces for clean logs
    errorMethodCount: 5, // Number of error trace lines
    lineLength: 100, // Adjusts line length for wrapping
  ),
);

// logger.v() (Verbose)	Low-level details for debugging	
//    Use when logging highly detailed, granular data (e.g., API responses, raw data parsing).
// logger.d() (Debug)	General debugging information	
//    Use for tracking app state changes, user interactions, and non-critical logs.
// logger.i() (Info)	High-level application flow	
//    Use for logging key events (e.g., "User logged in", "Payment successful").
// logger.w() (Warning)	Potential issues but not breaking	
//    Use when something unexpected happens, but the app can still function (e.g., "API response slow", "Cache miss").
// logger.e() (Error)	Serious issues, but app can recover	
//    Use when an error occurs but doesn’t crash the app (e.g., "Network request failed", "Invalid user input").
// logger.wtf() (What a Terrible Failure)	Critical failures	
//    Use for severe errors that should never happen (e.g., "Database corrupted", "App crash").