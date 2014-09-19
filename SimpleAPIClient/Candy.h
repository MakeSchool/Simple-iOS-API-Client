//
//  Candy.h
//  SimpleAPIClient
//
//  Created by Benjamin Encz on 19/09/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Candy : NSObject

@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger price;

+ (instancetype)candyWithJSONDictionary:(NSDictionary *)dictionary;

@end
