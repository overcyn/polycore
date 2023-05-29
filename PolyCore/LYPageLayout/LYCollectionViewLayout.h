#import <UIKit/UIKit.h>
#import "LYCollectionViewBehavior.h"

@interface LYCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes {
    @public CGRect optimizedFrame; // Access the frame property without objc_msg_send
}
@property (nonatomic) CGPoint offset;
@end

@interface LYCollectionViewLayout : UICollectionViewLayout
@end

@protocol LYCollectionViewDelegateLayout <UICollectionViewDelegate>
- (id<LYCollectionViewBehavior>)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout behaviorForSectionAtIndex:(NSInteger)section;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath insets:(UIEdgeInsets)insets;
- (CGSize)collectionView:(UICollectionView *)collectionView sizeThatFits:(CGSize)size atIndexPath:(NSIndexPath *)indexPath;
@end
