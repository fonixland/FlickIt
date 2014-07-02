//
//  ConstantsAndMacros.h
//  FlickIt
//
//  Created by Bill Weakley on 7/2/14.
//  Copyright (c) 2014 Fonixland Studios. All rights reserved.
//

#pragma mark - Constants - PROD VERSION

typedef void (^FNXObjectCallback)(__strong id, NSError *__strong);

//
// System Versioning Preprocessor Macros
//

#define FNX_FLICKR_API_KEY @"86dd8f59a08a9aac6f33fdf76c4d30cd"

// Macro wrapper for FNXDebugLog only if debug mode has been enabled
#ifdef DEBUG
#define FNXDebugLog(fmt,...) NSLog(@"%@",[NSString stringWithFormat:(fmt), ##__VA_ARGS__]);
#else
// If debug mode hasn't been enabled, don't do anything when the macro is called
#define FNXDebugLog(...)
#endif

// Log using the same parameters above but include the function name and source code line number in the log statement
#ifdef DEBUG
#define FNXDebugLogDetailed(fmt, ...) NSLog((@"Func: %s, Line: %d, " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define FNXDebugLogDetailed(...)
#endif

// This macro will create a detailed log message and run even during a production build
#define FNXDetailedLog(fmt, ...) NSLog((@"Func: %s, Line: %d, " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);