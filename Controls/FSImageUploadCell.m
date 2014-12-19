//
//  FSImageUploadCell.m
//  FashionShop
//
//  Created by gong yi on 1/2/13.
//  Copyright (c) 2013 Fashion. All rights reserved.
//

#import "FSImageUploadCell.h"
#import "FSImageCollectionCell.h"
#define I_LIKE_COLUMNS 3;
#define ITEM_CELL_WIDTH 100;
#define IMAGE_MODAL_IDENTIFIER 2000
@interface FSImageUploadCell()
{
    
}

@end
@implementation FSImageUploadCell
@synthesize imageContent;
@synthesize sizeIndex;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self prepareLayout];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self prepareLayout];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self prepareLayout];
    }
    return self;
}
-(void)prepareLayout
{
    SpringboardLayout *layout = [[SpringboardLayout alloc] init];
    layout.itemWidth = ITEM_CELL_WIDTH;
    layout.columnCount = I_LIKE_COLUMNS;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 5);
    layout.delegate = self;
    
    sizeIndex = -1;

    imageContent= [[PSUICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    imageContent.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imageContent.backgroundColor = [UIColor whiteColor];
    [self addSubview:imageContent];
    imageContent.delegate = self;
    imageContent.dataSource = self;
    imageContent.scrollEnabled = FALSE;
       
    //[imageContent registerNib:[UINib nibWithNibName:@"FSImageCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"FSImageCollectionCell"];
    [imageContent registerClass:[FSImageCollectionCell class] forCellWithReuseIdentifier:@"FSImageCollectionCell"];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(selectSizeImage:)];
    longPress.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:longPress];

}
-(void)refreshImages
{
    [imageContent reloadData];
}
-(void)setImages:(NSMutableArray *)images
{
    _images = images;
    [self refreshImages];
}

#pragma mark - PSUICollectionView Datasource

- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return _images?_images.count:0;
    
}

- (NSInteger)numberOfSectionsInCollectionView: (PSUICollectionView *)collectionView {
    
    return 1;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    int index = indexPath.row * [self numberOfSectionsInCollectionView:cv]+indexPath.section;
    int totalCount = _images.count;
    if (index>=totalCount)
        return nil;
    UIImage *item = [_images objectAtIndex:index];
    FSImageCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FSImageCollectionCell" forIndexPath:indexPath];
    cell.imageView.image = item;
    [cell.btnRemove addTarget:self action:@selector(doRemoveImage:) forControlEvents:UIControlEventTouchUpInside];
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor colorWithRed:151 green:151 blue:151].CGColor;
    CGRect _rect = cell.btnSizeSel.frame;
    _rect.origin.y = cell.frame.size.height - 30;
    cell.btnSizeSel.frame = _rect;
    if (sizeIndex == indexPath.row) {
        [cell.btnSizeSel setImage:[UIImage imageNamed:@"selected_icon.png"] forState:UIControlStateNormal];
    }
    else{
        [cell.btnSizeSel setImage:[UIImage imageNamed:@"unselect_icon.png"] forState:UIControlStateNormal];
    }
    
    return cell;
}
-(void)doRemoveImage:(UIButton *)sender
{
    FSImageCollectionCell *container = (FSImageCollectionCell*)sender.superview.superview;
    NSIndexPath *indexPath = [imageContent indexPathForCell:container ];
    if (indexPath)
    {
        [_images removeObjectAtIndex:indexPath.row];
//        if (!IOS7) {
//            [imageContent deleteItemsAtIndexPaths:@[indexPath]];
//        }
        [imageContent reloadData];
        if (sizeIndex == indexPath.row) {
            sizeIndex = -1;
        }
        if (_images.count<=0 &&
            _imageRemoveDelegate &&
            [_imageRemoveDelegate respondsToSelector:@selector(didImageRemoveAll)])
        {
            [_imageRemoveDelegate performSelector:@selector(didImageRemoveAll)];
        }
            
    }
}

-(void)didHideModalImage
{
    UIView *modalView = [theApp.window viewWithTag:IMAGE_MODAL_IDENTIFIER];
    if (modalView)
    {
        [modalView removeFromSuperview];
        modalView = nil;}
}
#pragma mark - spring board layout delegate

- (BOOL) isDeletionModeActiveForCollectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout
{
    return NO;
}

- (CGFloat)collectionView:(PSUICollectionView *)collectionView
                   layout:(SpringboardLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage * data = [_images objectAtIndex:indexPath.row];
    
    int cellWidth = ITEM_CELL_WIDTH;
    return (cellWidth * data.size.height)/(data.size.width);
   
}

/*
-(void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *modalImageView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIImageView *_imageView = [[UIImageView alloc] initWithFrame:modalImageView.frame];
    _imageView.image = [_images objectAtIndex:indexPath.row];
    _imageView.userInteractionEnabled = FALSE;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [modalImageView addSubview:_imageView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didHideModalImage)];
    [modalImageView addGestureRecognizer:tapGesture];
    modalImageView.tag = IMAGE_MODAL_IDENTIFIER;
    [theApp.window addSubview:modalImageView];
    [theApp.window bringSubviewToFront:modalImageView];
}
 */

#pragma mark - gesture-recognition action methods

-(void)tapImage:(UITapGestureRecognizer *)gr
{
    NSIndexPath *indexPath = [self.imageContent indexPathForItemAtPoint:[gr locationInView:self.imageContent]];
    if (indexPath)
    {
        UIView *modalImageView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        UIImageView *_imageView = [[UIImageView alloc] initWithFrame:modalImageView.frame];
        _imageView.image = [_images objectAtIndex:indexPath.row];
        _imageView.userInteractionEnabled = FALSE;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [modalImageView addSubview:_imageView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didHideModalImage)];
        [modalImageView addGestureRecognizer:tapGesture];
        modalImageView.tag = IMAGE_MODAL_IDENTIFIER;
        [theApp.window addSubview:modalImageView];
        [theApp.window bringSubviewToFront:modalImageView];
    }
}

- (void)selectSizeImage:(UILongPressGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan)
    {
        NSIndexPath *indexPath = [self.imageContent indexPathForItemAtPoint:[gr locationInView:self.imageContent]];
        if (indexPath)
        {
            if (sizeIndex == indexPath.row) {
                sizeIndex = -1;
            }
            else{
                sizeIndex = indexPath.row;
            }
            if (_sizeSelDelegate && [_sizeSelDelegate respondsToSelector:@selector(selectSizeImageWithIndex:)]) {
                id value = [_sizeSelDelegate performSelector:@selector(selectSizeImageWithIndex:) withObject:[NSNumber numberWithInt:sizeIndex]];
                if (!value) {
                    sizeIndex = -1;
                }
            }
            [self.imageContent reloadData];
        }
    }
}

@end
