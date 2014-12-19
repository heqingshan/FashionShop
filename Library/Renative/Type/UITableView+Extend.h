//
//  UITableView+Extend.h
//  FashionShop
//
//  Created by gong yi on 12/26/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView(Reuseable)

- (id) dequeueReusableCellWithIdentifier:(NSString *)cellIdentifier forIndexPath:(NSIndexPath *)indexPath;
- (void) registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;
- (void) registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

@end
