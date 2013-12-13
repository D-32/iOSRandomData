//
//  Contacts.m
//  iOSRandomData
//
//  Created by Dylan Marriott on 13.12.13.
//  Copyright (c) 2013 Dylan Marriott. All rights reserved.
//

#import "Contacts.h"
#import <AddressBook/AddressBook.h>
#import "Contact.h"

@implementation Contacts

+ (void)addRandomContacts:(int)amount {
	ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
	
	if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
		ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
			// First time access has been granted, add the contact
			[Contacts addContacts:amount];
		});
	} else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
		// The user has previously given access, add the contact
		[Contacts addContacts:amount];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Access Denied" message:@"Please give access to AddressBook via settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		// The user has previously denied access
		// Send an alert telling user to change privacy setting in settings app
	}
}

+ (void)addContacts:(int)amount {
	ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
	
	NSMutableArray* contacts = [[NSMutableArray alloc] init];
	NSString* fileString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"contacts" ofType:@"csv"] encoding:NSUTF8StringEncoding error:nil];
    NSArray* lines = [fileString componentsSeparatedByString:@"\n"];
    for (NSString* line in lines) {
        NSArray* split = [line componentsSeparatedByString:@";"];
        
		Contact* contact = [[Contact alloc] init];
		
		contact.firstName = split[0];
		contact.name = split[1];
		contact.mail = split[2];
		contact.phone = split[3];
		contact.street = split[4];
		contact.city = split[5];
		contact.zip = split[6];
		contact.country = split[7];
		NSString* dateString = split[8];
		NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSDate* date = [dateFormatter dateFromString:dateString];
		contact.birthday = date;
		
		[contacts addObject:contact];
    }

	
	for (int i = 0; i < amount; i++) {
		ABRecordRef person = ABPersonCreate();
		
		Contact* contact = [[Contact alloc] init];
		contact.firstName = [Contacts randomContact:contacts].firstName;
		contact.name      = [Contacts randomContact:contacts].name;
		contact.mail      = [Contacts randomContact:contacts].mail;
		contact.phone     = [Contacts randomContact:contacts].phone;
		contact.street    = [Contacts randomContact:contacts].street;
		contact.city      = [Contacts randomContact:contacts].city;
		contact.zip       = [Contacts randomContact:contacts].zip;
		contact.country   = [Contacts randomContact:contacts].country;
		contact.birthday  = [Contacts randomContact:contacts].birthday;
		
		ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFStringRef) contact.firstName, NULL);
		ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFStringRef) contact.name, NULL);
		
		ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
		ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFStringRef) contact.mail, kABWorkLabel, NULL);
		ABRecordSetValue(person, kABPersonEmailProperty, emailMultiValue, nil);
		CFRelease(emailMultiValue);

		ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
		ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFStringRef) contact.phone, kABPersonPhoneMainLabel, NULL);
		ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
		CFRelease(phoneNumberMultiValue);
		
		ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
		NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
		
		addressDictionary[(NSString *) kABPersonAddressStreetKey] = contact.street;
		addressDictionary[(NSString *)kABPersonAddressCityKey] = contact.city;
		addressDictionary[(NSString *)kABPersonAddressZIPKey] = contact.zip;
		addressDictionary[(NSString *)kABPersonAddressCountryKey] = contact.country;
		
		ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFDictionaryRef) addressDictionary, kABWorkLabel, NULL);
		ABRecordSetValue(person, kABPersonAddressProperty, multiAddress, NULL);
		
		ABAddressBookAddRecord(addressBook, person, NULL);
	}
	
	ABAddressBookSave(addressBook, NULL);
	CFRelease(addressBook);
	
	NSLog(@"Added %i contacts", amount);
}

+ (Contact *)randomContact:(NSArray *)contacts {
	NSUInteger randomIndex = arc4random() % [contacts count];
	return [contacts objectAtIndex:randomIndex];
}

@end
