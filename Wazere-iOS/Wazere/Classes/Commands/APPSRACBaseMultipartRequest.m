//
//  APPSBaseMultipartRequest.m
//  Wazere
//
//  Created by Bogdan Bilonog on 9/3/14.
//  Copyright (c) 2014 iOS Developer. All rights reserved.
//

#import <CocoaSecurity/CocoaSecurity.h>

#import "APPSRACBaseMultipartRequest.h"
#import "APPSMultipartModel.h"

@interface APPSRACBaseMultipartRequest ()

@end

@implementation APPSRACBaseMultipartRequest

@synthesize images = _images, imageName = _imageName;

- (instancetype)initWithObject:(APPSMultipartModel *)object
                        params:(NSDictionary *)params
                        method:(NSString *)method
                       keyPath:(NSString *)keyPath
                     imageName:(NSString *)imageName
                    disposable:(RACDisposable *)disposable {
  self = [super initWithObject:object
                        params:params
                        method:method
                       keyPath:keyPath
                    disposable:disposable];

  if (self) {
    _images = object.images;
    _imageName = imageName;
  }

  return self;
}

- (NSMutableURLRequest *)request {
  NSString *keyPath = [self createURLString];
  NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
      multipartFormRequestWithMethod:
          self.method URLString:[[NSURL URLWithString:keyPath
                                        relativeToURL:
                                            [NSURL URLWithString:BASE_URL_STRING]] absoluteString]
                          parameters:self.params
           constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
               for (UIImage *image in self.images) {
                 NSData *imageData = UIImageJPEGRepresentation(image, 1);
                 CocoaSecurityResult *md5 =
                     [CocoaSecurity md5:[NSString stringWithFormat:@"%@", [NSDate date]]];
                 NSString *imageName = @"image";
                 if (self.imageName) {
                   imageName = self.imageName;
                 }
                 [formData
                     appendPartWithFileData:imageData
                                       name:imageName
                                   fileName:[NSString stringWithFormat:@"%@.jpeg", md5.hexLower]
                                   mimeType:@"image/jpeg"];
               }
           } error:nil];
  return request;
}

@end
