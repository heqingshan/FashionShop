//
//  UITableView+Extend.m
//  FashionShop
//
//  Created by gong yi on 12/26/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "UITableView+Extend.h"
#import <objc/runtime.h>

#define kUITableViewReuseable "reusableKey"

@interface UITableViewExt : NSObject
@property (nonatomic, strong) NSMutableDictionary *cellNibDict;
@property (nonatomic, strong) NSMutableDictionary *cellClassDict;
@end
@implementation UITableViewExt
@end


@implementation UITableView(Reuseable)

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    NSParameterAssert(cellClass);
    NSParameterAssert(identifier);
    [self ensureVarContext];
    [[self extVars].cellClassDict setValue:cellClass forKey:identifier];
   
}

-(void) ensureVarContext
{
    UITableViewExt *exts = [self extVars];
    if (!exts)
    {
        exts = [[UITableViewExt alloc] init];
        exts.cellNibDict = [[NSMutableDictionary alloc] init];
        exts.cellClassDict = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &kUITableViewReuseable,exts , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}
- (UITableViewExt *)extVars {
    return objc_getAssociatedObject(self, &kUITableViewReuseable);
}

- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier {
    [self ensureVarContext];
    [[self extVars].cellNibDict setValue:nib forKey:identifier];

}

- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    // de-queue cell (if available)
    UITableViewCell*cell = [self dequeueReusableCellWithIdentifier:identifier];

    if (!cell) {
        if ([self extVars].cellNibDict[identifier]) {
            // Cell was registered via registerNib:forCellWithReuseIdentifier:
            UINib *cellNib = [self extVars].cellNibDict[identifier];
            cell = [cellNib instantiateWithOwner:self options:nil][0];
            
        } else {
            Class cellClass = [self extVars].cellClassDict[identifier];
            cell = [[cellClass alloc] init];
           
        }
    }
    return cell;
}


@end
