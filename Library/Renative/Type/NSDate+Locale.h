//
//  NSDate+Locale.h
//  FashionShop
//
//  Created by gong yi on 12/9/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(locale)

-(NSString *) toLocalizedString;

-(BOOL) isSameDay:(NSDate *)toDate;
@end
