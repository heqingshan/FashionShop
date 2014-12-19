//
//  NSDate+Locale.m
//  FashionShop
//
//  Created by gong yi on 12/9/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "NSDate+Locale.h"

#define SECONDS_OF_DAY 60*60*24
@implementation NSDate(locale)

-(NSString *)toLocalizedString
{
    NSTimeInterval timeInterval = abs([self timeIntervalSinceNow]);
    if (timeInterval <= 300) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM-dd HH:mm:ss"];
        return [df stringFromDate:self];
    }
    NSTimeInterval minutesInternal = 60;
    NSTimeInterval hourInternal = 60*60;
    NSTimeInterval dayInternal = 60*60*24;
    int days = (int)floor(timeInterval/dayInternal);
    int hours = (int)floor((timeInterval-days*dayInternal)/hourInternal);
    int minutes = (int)floor((timeInterval-days*dayInternal-hours*hourInternal)/minutesInternal);
    if (days>0)
        return [NSString stringWithFormat:NSLocalizedString(@"%d days before", nil),days];
    else if(hours>0)
        return [NSString stringWithFormat:NSLocalizedString(@"%d hours before", nil),hours];
    else if (minutes>0)
        return [NSString stringWithFormat:NSLocalizedString(@"%d minutes before", nil),minutes];
    else
        return [NSString stringWithFormat:NSLocalizedString(@"one minute before", nil)];
}

-(BOOL) isSameDay:(NSDate *)toDate
{
    NSDateFormatter *mdf = [[NSDateFormatter alloc]init];
    [mdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *formatDate = [mdf dateFromString:[mdf stringFromDate:toDate]];
    NSDate *selfDate = [mdf dateFromString:[mdf stringFromDate:self]];
    NSTimeInterval interval = [selfDate timeIntervalSinceDate:formatDate];
    if (interval==0)
        return TRUE;
    return FALSE;
}


@end
