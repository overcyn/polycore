#import <UIKit/UIKit.h>
@protocol LYSection;
@protocol LYBarButtonItem;
@protocol LYPageDelegate;
@class LYPageOutput;
@class LYPageInput;

@protocol LYPage <NSObject>
@property (nonatomic, weak) id<LYPageDelegate> _Nullable delegate;
@optional
@property (nonatomic, assign) BOOL renderImmediately;
- (void)pageWillAppear;
- (void)pageWillDisappear;
- (void)pageDidAppear;
- (void)pageDidDisappear;
- (LYPageOutput *_Nonnull)render:(LYPageInput * _Nonnull)input;
@end

@interface LYPageInput: NSObject
@property (nonatomic, strong) UIViewController * _Nonnull viewController;
@end

@interface LYPageOutput: NSObject
@property (nonatomic, strong) NSArray<id<LYSection>> * _Nonnull sections;
@property (nonatomic, strong) NSString * _Nullable title;
@property (nonatomic, strong) UIView * _Nullable titleView;
@property (nonatomic, strong) NSArray<id <LYBarButtonItem>> *_Nullable rightBarItems;
@property (nonatomic, strong) NSArray<id <LYBarButtonItem>> *_Nullable leftBarItems;
@property (nonatomic, assign) BOOL leftItemsSupplementBackButton;
@property (nonatomic, strong) NSArray<UIBarButtonItem *> *_Nullable toolbarItems;
//@property (nonatomic, assign) UIStatusBarStyle preferredStatusBarStyle;
@property (nonatomic, assign) UINavigationItemLargeTitleDisplayMode largeTitleDisplayMode;
@property (nonatomic, assign) BOOL hidesSearchBarWhenScrolling;
@property (nonatomic, strong) UIColor * _Nonnull backgroundColor;
@property (nonatomic, assign) BOOL hidesBackButton;
@property (nonatomic, assign) BOOL hidesNavigationBar;
@property (nonatomic, assign) BOOL scrollEnabled;
@property (nonatomic, assign) BOOL shouldAutorotate;
@property (nonatomic, assign) UIScrollViewContentInsetAdjustmentBehavior contentInsetAdjustmentBehavior;
@property (nonatomic, strong) UIRefreshControl * _Nullable refreshControl;
@property (nonatomic, strong) UISearchController * _Nullable searchController;
@property (nonatomic, strong) UITabBarItem * _Nullable tabBarItem;
@end

// This is the interface that LYPageViewController exposes to the LYPages
@protocol LYPageDelegate <NSObject>
- (void)pageDidUpdate:(id<LYPage> _Nonnull)page;
- (UIViewController * _Nonnull)pageViewController;
@end

@protocol LYBarButtonItem <NSObject>
- (Class _Nonnull)barButtonItemClass;
- (void)configure:(UIBarButtonItem * _Nonnull)barButtonItem forViewController:(UIViewController * _Nonnull)viewController;
@end
