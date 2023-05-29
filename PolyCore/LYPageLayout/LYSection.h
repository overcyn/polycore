#import <UIKit/UIKit.h>
#import "LYCollectionViewLayout.h"
@protocol LYSectionDelegate;
@protocol LYSectionController;

@protocol LYSection <NSObject>
- (id<LYSectionController> _Nonnull)newSectionController;
@optional
@property (nonatomic, readonly) NSString * _Nullable identifier;
@end

@protocol LYSectionController <NSObject>
@required
@property (nonatomic, weak) id<LYSectionDelegate> _Nullable delegate;
- (void)setup;
- (UICollectionViewCell * _Nonnull)cellForItemAtIndex:(NSInteger)index;
- (CGSize)sizeForItemAtIndex:(NSInteger)index thatFits:(CGSize)size;
- (void)configureCell:(UICollectionViewCell * _Nonnull)cell at:(NSInteger)index;
@optional
@property (nonatomic, readonly) NSInteger count;
@property (nonatomic, readonly) id<LYCollectionViewBehavior> _Nullable behavior;
- (void)selectItemAtIndex:(NSInteger)index;
- (UIContextMenuConfiguration * _Nullable)contextMenuAtIndex:(NSInteger)index;
@end

// This is the interface that LYPageViewController exposes to the LYSectionControllers
@protocol LYSectionDelegate <NSObject>
- (UIViewController * _Nullable)parentViewControllerForSection:(id<LYSectionController> _Nonnull)section;
- (void)section:(id<LYSectionController> _Nonnull)section registerClass:(Class _Nonnull)class forCellWithReuseIdentifier:(NSString * _Nonnull)reuseId;
- (UICollectionViewCell * _Nullable)section:(id<LYSectionController> _Nonnull)section dequeueReusableCellWithReuseIdentifier:(NSString * _Nonnull)reuseId forIndex:(NSInteger)index;
- (UICollectionViewCell * _Nullable)section:(id<LYSectionController> _Nonnull)section cellForItemAtIndex:(NSInteger)index;
@end
