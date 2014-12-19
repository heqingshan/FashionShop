//  SpringboardLayout.h

#import <UIKit/UIKit.h>

@class  SpringboardLayout;

@protocol SpringboardLayoutDelegate <PSUICollectionViewDelegateFlowLayout>

@required

- (BOOL) isDeletionModeActiveForCollectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout;

- (CGFloat)collectionView:(PSUICollectionView *)collectionView
                   layout:(SpringboardLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface SpringboardLayout : PSUICollectionViewFlowLayout
@property (nonatomic, weak) id<SpringboardLayoutDelegate> delegate;
@property (nonatomic, assign) NSUInteger columnCount; // How many columns
@property (nonatomic, assign) CGFloat itemWidth; // Width for every column
@property (nonatomic, assign) UIEdgeInsets sectionInset; // The margins used to lay out content in a section
@end
