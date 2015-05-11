//
//  APPSHTTTPConstants.h
//  Wazere
//
//  Created by Bogdan Bilonog on 9/22/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#ifndef Wazere_APPSHTTTPConstants_h
#define Wazere_APPSHTTTPConstants_h

// HTTP methods
static NSString* const HTTPMethodGET = @"GET";
static NSString* const HTTPMethodPOST = @"POST";
static NSString* const HTTPMethodPUT = @"PUT";
static NSString* const HTTPMethodDELETE = @"DELETE";

typedef NS_ENUM(NSInteger, HTTPStausCode) {
  HTTPStausCodeOK = 200,
  HTTPStausCodeNotFound = 404,
  HTTPStausCodeUnauthorized = 401,
  HTTPStausCodeGone = 410,
  HTTPStausCodeLocked = 423,
  HTTPStausCodeForbidden = 403,
  HTTPStausCodeBadParams = 422,
  HTTPStausCodeCanceled = -999
};

#endif
