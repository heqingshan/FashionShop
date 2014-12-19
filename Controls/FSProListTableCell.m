//
//  FSProListTableCell.m
//  FashionShop
//
//  Created by gong yi on 11/17/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSProListTableCell.h"
#import "CoreLocation/CLLocation.h"
#import "FSLocationManager.h"

@implementation FSProListTableCell
@synthesize lblDistance,lblDuration,lblTitle,data;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setData:(FSProItemEntity *)source{
    data = source;
    [lblTitle setValue:data.title forKey:@"text"];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy/MM/dd"];
    [lblDuration setValue:[NSString stringWithFormat:@"%@-%@",[formater stringFromDate:data.startDate],[formater stringFromDate:data.endDate]] forKey:@"text"];
    lblDistance.text = [NSString stringWithFormat:@"%d公里",(int)data.store.distance/1000];
    
}

@end
