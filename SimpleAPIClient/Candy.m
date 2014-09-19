//
//  Candy.m
//  SimpleAPIClient
//
//  Created by Benjamin Encz on 19/09/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "Candy.h"

@implementation Candy

+ (instancetype)candyWithJSONDictionary:(NSDictionary *)dictionary {
    Candy *candy = [Candy new];
    
    candy.title = dictionary[@"name"];
    candy.price = [dictionary[@"price"] integerValue];
    
    return candy;
}

@end
