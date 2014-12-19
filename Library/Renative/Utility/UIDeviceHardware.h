//
//  UIDeviceHardware.h
//
//  Used to determine EXACT version of device software is running on.

#import <Foundation/Foundation.h>

@interface UIDeviceHardware : NSObject 

+ (UIDeviceHardware *)currentDevice;
- (NSString *) platform;
- (NSString *) platformString;

@end