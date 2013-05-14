//
//  Tweet.h
//  Tweet Search
//
//  Created by DEVFLOATER28-XL on 2013-05-09.
//  Copyright (c) 2013 DEVFLOATER28-XL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject

@property NSString* userName;
@property NSString* userImageUrl;
@property NSString* text;
@property NSData* imageData;
@property NSString* createdAt;

@end
