//  SpringboardLayoutAttributes.m

#import "SpringboardLayoutAttributes.h"

@implementation SpringboardLayoutAttributes

@synthesize deleteButtonHidden=_deleteButtonHidden;

- (id)copyWithZone:(NSZone *)zone
{
    SpringboardLayoutAttributes *attributes = [super copyWithZone:zone];
    attributes.deleteButtonHidden = _deleteButtonHidden;
    return attributes;
}
@end
