//  SpringboardLayout.m

#import "SpringboardLayout.h"
#import "SpringboardLayoutAttributes.h" // TO UNCOMMENT LATER

@interface SpringboardLayout()
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, assign) CGFloat interitemSpacing;
@property (nonatomic, strong) NSMutableArray *columnHeights; // height for each column
@property (nonatomic, strong) NSMutableArray *itemAttributes; // attributes for each item
@end


@implementation SpringboardLayout
@synthesize columnCount = _columnCount,itemWidth = _itemWidth,sectionInset = _sectionInset;
- (id)init
{
    if (self = [super init])
    {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        _sectionInset = UIEdgeInsetsZero;
    }
    return self;
}

- (BOOL)isDeletionModeOn
{
    if ([[self.collectionView.delegate class] conformsToProtocol:@protocol(SpringboardLayoutDelegate)])
    {
        return [(id)self.collectionView.delegate isDeletionModeActiveForCollectionView:self.collectionView layout:self];
        
    }
    return NO;
    
}

// INSERT ATTRIBUTES SNIPPET HERE

+ (Class)layoutAttributesClass
{
    return [SpringboardLayoutAttributes class];
}

- (SpringboardLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
   // SpringboardLayoutAttributes *attributes = (SpringboardLayoutAttributes *)[super layoutAttributesForItemAtIndexPath:indexPath];
    SpringboardLayoutAttributes *attributes = (self.itemAttributes)[indexPath.item];
    if ([self isDeletionModeOn])
        attributes.deleteButtonHidden = NO;
    else
        attributes.deleteButtonHidden = YES;
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributesArrayInRect = self.itemAttributes;
    
    for (SpringboardLayoutAttributes *attribs in attributesArrayInRect)
    {
        if ([self isDeletionModeOn]) attribs.deleteButtonHidden = NO;
        else attribs.deleteButtonHidden = YES;
    }
    return attributesArrayInRect;
}


#pragma mark - Accessors
- (void)setColumnCount:(NSUInteger)columnCount
{
    if (_columnCount != columnCount) {
        _columnCount = columnCount;
        [self invalidateLayout];
    }
}

- (void)setItemWidth:(CGFloat)itemWidth
{
    if (_itemWidth != itemWidth) {
        _itemWidth = itemWidth;
        [self invalidateLayout];
    }
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset)) {
        _sectionInset = sectionInset;
        [self invalidateLayout];
    }
}

#pragma mark - Life cycle
- (void)dealloc
{
    [_columnHeights removeAllObjects];
    _columnHeights = nil;
    
    [_itemAttributes removeAllObjects];
    _itemAttributes = nil;
}

#pragma mark - Methods to Override
- (void)prepareLayout
{
    if (!IOS7) {
        [super prepareLayout];
    }
    
    _itemCount = [[self collectionView] numberOfItemsInSection:0];
    
    NSAssert(_columnCount > 1, @"columnCount for UICollectionViewWaterfallLayout should be greater than 1.");
    CGFloat width = self.collectionView.frame.size.width - _sectionInset.left - _sectionInset.right;
    _interitemSpacing = floorf((width - _columnCount * _itemWidth) / (_columnCount - 1));
    
    _itemAttributes = [NSMutableArray arrayWithCapacity:_itemCount];
    _columnHeights = [NSMutableArray arrayWithCapacity:_columnCount];
    for (NSInteger idx = 0; idx < _columnCount; idx++) {
        [_columnHeights addObject:@(_sectionInset.top)];
    }
    
    // Item will be put into shortest column.
    for (NSInteger idx = 0; idx < _itemCount; idx++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        CGFloat itemHeight = [self.delegate collectionView:self.collectionView
                                                    layout:self
                                  heightForItemAtIndexPath:indexPath];
        NSUInteger columnIndex = [self shortestColumnIndex];
        CGFloat xOffset = _sectionInset.left + (_itemWidth + _interitemSpacing) * columnIndex;
        CGFloat yOffset = [(_columnHeights[columnIndex]) floatValue];
        CGPoint itemCenter = CGPointMake(floorf(xOffset + _itemWidth/2), floorf((yOffset + itemHeight/2)));
        
        SpringboardLayoutAttributes *attributes =
        [SpringboardLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.size = CGSizeMake(self.itemWidth, itemHeight);
        attributes.center = itemCenter;
        [_itemAttributes addObject:attributes];
        _columnHeights[columnIndex] = @(yOffset + itemHeight + _interitemSpacing);
    }
}

- (CGSize)collectionViewContentSize
{
    if (self.itemCount == 0) {
        CGSize contentSize = self.collectionView.frame.size;
        return CGSizeMake(contentSize.width,contentSize.height+60);
    }
    
    CGSize contentSize = self.collectionView.frame.size;
    NSUInteger columnIndex = [self longestColumnIndex];
    CGFloat height = [self.columnHeights[columnIndex] floatValue];
    contentSize.height = MAX(contentSize.height+20,height - self.interitemSpacing + self.sectionInset.bottom+20);
    return contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

#pragma mark - Private Methods
// Find out shortest column.
- (NSUInteger)shortestColumnIndex
{
    __block NSUInteger index = 0;
    __block CGFloat shortestHeight = MAXFLOAT;
    
    [self.columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height < shortestHeight) {
            shortestHeight = height;
            index = idx;
        }
    }];
    
    return index;
}

// Find out longest column.
- (NSUInteger)longestColumnIndex
{
    __block NSUInteger index = 0;
    __block CGFloat longestHeight = 0;
    
    [self.columnHeights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGFloat height = [obj floatValue];
        if (height > longestHeight) {
            longestHeight = height;
            index = idx;
        }
    }];
    
    return index;
}

@end
