//
//  Address.h
//  iOSRandomData
//
//  Created by Dylan Marriott on 13.12.13.
//  Copyright (c) 2013 Dylan Marriott. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic) NSString* firstName;
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* mail;
@property (nonatomic) NSString* phone;
@property (nonatomic) NSString* street;
@property (nonatomic) NSString* city;
@property (nonatomic) NSString* zip;
@property (nonatomic) NSString* country;
@property (nonatomic) NSDate* birthday;

@end
