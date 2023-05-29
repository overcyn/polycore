#import <UIKit/UIKit.h>
@protocol LYPage;

@interface LYPageViewController : UIViewController
- (instancetype _Nonnull)initWithPage:(id<LYPage> _Nonnull)page;
@property (nonatomic, readonly) id<LYPage> _Nonnull page;
@end
