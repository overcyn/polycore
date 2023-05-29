#import "LYPageViewController.h"
#import "LYSection.h"
#import "LYPage.h"
#import "LYCollectionViewLayout.h"
#import "UIKit+LYAdditions.h"

NSString * const LYPageViewControllerEmptyIdentifier = @"LYPageViewControllerEmptyIdentifier";

@interface LYPageViewController () <UICollectionViewDelegate, UICollectionViewDataSource, LYSectionDelegate, LYPageDelegate, LYCollectionViewDelegateLayout>
@end

@implementation LYPageViewController {
    NSArray<id<LYSection>> *_sections;
    NSMutableArray *_sectionControllers;
    UICollectionView *_collectionView;
    NSIndexPath *_contextMenuIndexPath;
    id<LYPage> _page;
    BOOL _viewWillAppear;
    BOOL _viewDidAppear;
    BOOL _shouldAutorotate;
    BOOL _reloading;
    UIEdgeInsets _safeAreaInsets;
}

- (instancetype)initWithPage:(id<LYPage>)page {
    if (([self initWithNibName:nil bundle:nil])) {
        _sections = (NSArray<LYSection> *)@[];
        _sectionControllers = [NSMutableArray array];
        _shouldAutorotate = true;
        _safeAreaInsets = [_collectionView safeAreaInsets];
        _page = page;
        if ([_page respondsToSelector:@selector(setDelegate:)]) {
            [_page setDelegate:self];
        }
    }
    return self;
}

- (void)dealloc {
    [_collectionView setDelegate:nil];
    [_collectionView setDataSource:nil];
}

#pragma mark - API

@synthesize page = _page;

#pragma mark - UIViewController

- (void)loadView {
    LYCollectionViewLayout *layout = [[LYCollectionViewLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView setAlwaysBounceVertical:YES];
    [_collectionView setBackgroundColor:[UIColor systemBackgroundColor]];
    [_collectionView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [_collectionView setDelaysContentTouches:NO];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:LYPageViewControllerEmptyIdentifier];
    [self setView:_collectionView];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    [self pageDidUpdate:_page];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BOOL hasAppeared = _viewWillAppear;
    _viewWillAppear = true;
    if (!hasAppeared) {
        [self pageDidUpdate:_page];
    }
    [_collectionView LYDeselectAllItems];
    if ([_page respondsToSelector:@selector(pageWillAppear)]) {
        [_page pageWillAppear];
    }
//    if ([_page respondsToSelector:@selector(hidesNavigationBar)] && [_page hidesNavigationBar]) {
//        [[self navigationController] setNavigationBarHidden:YES animated:animated];
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _viewDidAppear = true;
    if ([_page respondsToSelector:@selector(pageDidAppear)]) {
        [_page pageDidAppear];
    }
    
//    // KD: Hack to fix missing nav bar when cancelling out of swipe back gesture. Something to do with changing statusBar styles.
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if ([self->_page respondsToSelector:@selector(hidesNavigationBar)] && [self->_page hidesNavigationBar]) {
//            [[self navigationController] setNavigationBarHidden:YES animated:NO];
//        } else {
//            [[self navigationController] setNavigationBarHidden:NO animated:NO];
//        }
//    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([_page respondsToSelector:@selector(pageWillDisappear)]) {
        [_page pageWillDisappear];
    }
//    if ([_page respondsToSelector:@selector(hidesNavigationBar)] && [_page hidesNavigationBar] && [[self navigationController] topViewController] != self) { // KD: WEIRD HACK
//        [[self navigationController] setNavigationBarHidden:NO animated:animated];
//    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([_page respondsToSelector:@selector(pageDidDisappear)]) {
        [_page pageDidDisappear];
    }
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    if ([_page respondsToSelector:@selector(preferredStatusBarStyle)]) {
//        return [_page preferredStatusBarStyle];
//    }
//    return [super preferredStatusBarStyle];
//}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    if ([[self traitCollection] userInterfaceStyle] != [previousTraitCollection userInterfaceStyle]) {
        [self pageDidUpdate:_page];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self pageDidUpdate:self->_page];
    } completion:nil];
}

- (BOOL)shouldAutorotate {
    return _shouldAutorotate;
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    
    // Don't reload the page when pulling down on a modal
    if (_safeAreaInsets.left != [_collectionView safeAreaInsets].left || _safeAreaInsets.right != [_collectionView safeAreaInsets].right) {
        [self pageDidUpdate:_page];
    }
    _safeAreaInsets = [_collectionView safeAreaInsets];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [_sectionControllers count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)index {
    // Try to recover if UICollectionView requests an out of bounds section. Still unclear why this is happening.
    if (index >= [_sectionControllers count]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_collectionView reloadData];
            [self->_collectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self numberOfSectionsInCollectionView:self->_collectionView])]];
        });
        return 0;
    }
    
    id<LYSectionController> section = _sectionControllers[index];
    if ([section respondsToSelector:@selector(count)]) {
        return [section count];
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Try to recover if UICollectionView requests an out of bounds section. Still unclear why this is happening.
    if ([indexPath section] >= [_sectionControllers count]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_collectionView reloadData];
            [self->_collectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self numberOfSectionsInCollectionView:self->_collectionView])]];
        });
        return [_collectionView dequeueReusableCellWithReuseIdentifier:LYPageViewControllerEmptyIdentifier forIndexPath:indexPath];
    }
    
    UICollectionViewCell *cell = [_sectionControllers[[indexPath section]] cellForItemAtIndex:[indexPath item]];
    [cell setNeedsLayout];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    id<LYSectionController> section = _sectionControllers[[indexPath section]];
    if ([section respondsToSelector:@selector(selectItemAtIndex:)]) {
        return true;
    }
    return false;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    id<LYSectionController> section = _sectionControllers[[indexPath section]];
    if ([section respondsToSelector:@selector(selectItemAtIndex:)]) {
        return true;
    }
    return false;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    id<LYSectionController> section = _sectionControllers[[indexPath section]];
    if ([section respondsToSelector:@selector(selectItemAtIndex:)]) {
        [section selectItemAtIndex:[indexPath item]];
    }
    [_collectionView deselectItemAtIndexPath:indexPath animated:false];
}

- (UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    _contextMenuIndexPath = indexPath;
    id<LYSectionController> section = _sectionControllers[[indexPath section]];
    if ([section respondsToSelector:@selector(contextMenuAtIndex:)]) {
        return [section contextMenuAtIndex:[indexPath item]];
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator {
    [self collectionView:_collectionView didSelectItemAtIndexPath:_contextMenuIndexPath];
}


#pragma mark - LYCollectionViewDelegateLayout

- (id<LYCollectionViewBehavior>)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout behaviorForSectionAtIndex:(NSInteger)index {
    id<LYSectionController> section = _sectionControllers[index];
    return [section respondsToSelector:@selector(behavior)] ? [section behavior] : nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath insets:(UIEdgeInsets)insets {
    CGSize size = [[self view] frame].size;
    size.height -= [_collectionView scrollIndicatorInsets].top + [_collectionView scrollIndicatorInsets].bottom;
    size.height -= insets.top + insets.bottom;
    size.width -= insets.left + insets.right;
    return [_sectionControllers[[indexPath section]] sizeForItemAtIndex:[indexPath item] thatFits:size];
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeThatFits:(CGSize)size atIndexPath:(NSIndexPath *)indexPath {
    return [_sectionControllers[[indexPath section]] sizeForItemAtIndex:[indexPath item] thatFits:size];
}

#pragma mark - LYPageDelegate

- (UIViewController *)pageViewController {
    return self;
}

- (void)pageDidUpdate:(id<LYPage>)page {
    // Don't reload if already reloading. Can occur when updating the collectionView in landscape triggers viewSafeAreaInsetsDidChange to be called.
    if (_reloading) {
        return;
    }
    _reloading = true;
    
    // PanModal doesn't have a parentViewController, so we need a way for it to force a render
    BOOL renderImmediately = false;
    if ([page respondsToSelector:@selector(renderImmediately)]) {
        renderImmediately = [page renderImmediately];
    }
    
    // Don't reload the collectionView before _viewWillAppear gets called. Causes large navigation titles to get collapsed.
    if (([self parentViewController] != nil && _viewWillAppear) || renderImmediately) {
        [self _pageDidUpdate:page];
    }
    _reloading = false;
}

- (void)_pageDidUpdate:(id<LYPage>)page {
    LYPageOutput *output;
    if ([_page respondsToSelector:@selector(render:)]) {
        LYPageInput *input = [[LYPageInput alloc] init];
        input.viewController = self;
        output = [_page render:input];
    } else {
        output = [[LYPageOutput alloc] init];
    }

    [[self navigationItem] setTitle:[output title]];
    {
        NSMutableArray<UIBarButtonItem *> *prevBarButtonItems = [[[self navigationItem] rightBarButtonItems] mutableCopy];
        NSMutableArray<UIBarButtonItem *> *rightBarButtonItems = [NSMutableArray array];
        for (id<LYBarButtonItem> i in [output rightBarItems]) { // Reuse UIBarButtonItems as much as possible
            UIBarButtonItem *item = [prevBarButtonItems firstObject];
            if (item == nil) {
                item = [[[i barButtonItemClass] alloc] init];
            } else {
                [prevBarButtonItems removeObjectAtIndex:0];
            }
            [i configure:item forViewController:self];
            [rightBarButtonItems addObject:item];
        }
        [[self navigationItem] setRightBarButtonItems:rightBarButtonItems];
    }
    if ([output leftBarItems] != nil) {
        NSMutableArray<UIBarButtonItem *> *prevBarButtonItems = [[[self navigationItem] leftBarButtonItems] mutableCopy];
        NSMutableArray<UIBarButtonItem *> *leftBarButtonItems = [NSMutableArray array];
        for (id<LYBarButtonItem> i in [output leftBarItems]) { // Reuse UIBarButtonItems as much as possible
            UIBarButtonItem *item = [prevBarButtonItems firstObject];
            if (item == nil) {
                item = [[[i barButtonItemClass] alloc] init];
                item.title = @"test";
            } else {
                [prevBarButtonItems removeObjectAtIndex:0];
            }
            [i configure:item forViewController:self];
            [leftBarButtonItems addObject:item];
        }
        [[self navigationItem] setLeftBarButtonItems:leftBarButtonItems];
        [[self navigationItem] setLeftItemsSupplementBackButton: [output leftItemsSupplementBackButton]];
    }
    [[self navigationItem] setTitleView:[output titleView]];
    [[self navigationItem] setHidesBackButton:[output hidesBackButton]];
    [[self navigationItem] setLargeTitleDisplayMode:[output largeTitleDisplayMode]];
    [[self navigationItem] setHidesSearchBarWhenScrolling:[output hidesSearchBarWhenScrolling]];
    [[self navigationItem] setSearchController:[output searchController]];
    [_collectionView setScrollEnabled:[output scrollEnabled]];
    [_collectionView setContentInsetAdjustmentBehavior:[output contentInsetAdjustmentBehavior]];
    [[self view] setBackgroundColor:[output backgroundColor]];
    if ([output refreshControl] != [_collectionView refreshControl]) {
        [_collectionView setRefreshControl:[output refreshControl]];
    }
    if ([output toolbarItems]) {
        NSArray *toolbarItems = [output toolbarItems];
        [self setToolbarItems:toolbarItems];
        [[self navigationController] setToolbarHidden:toolbarItems == nil];
    } else {
        [[self navigationController] setToolbarHidden:true];
    }
    
    if ([output tabBarItem]) {
        [self setTabBarItem:[output tabBarItem]];
    }
    _shouldAutorotate = [output shouldAutorotate];
    [_collectionView setScrollEnabled:[output scrollEnabled]];
    [self _reloadSections:[output sections]];
}

#pragma mark - LYSectionDelegate

- (UIViewController *)parentViewControllerForSection:(id<LYSectionController>)section {
    return self;
}

- (void)section:(id<LYSectionController>)section reloadItemsAtIndexes:(NSIndexSet *)indexSet {
    NSInteger sectionIndex = [_sectionControllers indexOfObject:section];
    NSMutableArray *array = [NSMutableArray array];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [array addObject:[NSIndexPath indexPathForItem:idx inSection:sectionIndex]];
    }];
    [_collectionView reloadItemsAtIndexPaths:array];
}

- (void)section:(id<LYSectionController>)section registerClass:(Class)class forCellWithReuseIdentifier:(NSString *)reuseId {
    [_collectionView registerClass:class forCellWithReuseIdentifier:reuseId];
}

- (UICollectionViewCell *)section:(id<LYSectionController>)section dequeueReusableCellWithReuseIdentifier:(NSString *)reuseId forIndex:(NSInteger)index {
    return [_collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:[NSIndexPath indexPathForItem:index inSection:[_sectionControllers indexOfObject:section]]];
}

- (UICollectionViewCell *)section:(id<LYSectionController>)section cellForItemAtIndex:(NSInteger)index {
    return [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:[_sectionControllers indexOfObject:section]]];
}

#pragma mark - Internal

- (void)_reloadSections:(NSArray<id<LYSection>> *)sections {
    [self view];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableIndexSet *indexesToAdd = [NSMutableIndexSet indexSet];
    NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet indexSet];
    NSInteger newSectionIndex = 0;
    // For each previous section
    for (NSInteger i = 0; i < _sections.count; i++) {
        // For each new section
        BOOL delete = true;
        for (NSInteger j = newSectionIndex; j < sections.count; j++) {
            id<LYSection> prevSection = _sections[i];
            id<LYSection> currSection = sections[j];
            
            NSString *prevIdentifier = ([prevSection respondsToSelector:@selector(identifier)]) ? prevSection.identifier : nil;
            NSString *currIdentifier = ([currSection respondsToSelector:@selector(identifier)]) ? currSection.identifier : nil;
            
            // If the new section is identical to the previous section
            if (_sections[i] == sections[j]) {
                id<LYSectionController> sectionController = _sectionControllers[i];
                // And if the previous section controller supports configuring cells
                if ([sectionController respondsToSelector:@selector(configureCell:at:)]) {
                    // Configure all of the visible cells with the previous section controller
                    NSInteger count = [sectionController respondsToSelector:@selector(count)] ? sectionController.count : 1;
                    for (NSInteger k = 0; k < count; k++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:k inSection:i];
                        UICollectionViewCell *visibleCell = [_collectionView cellForItemAtIndexPath:indexPath];
                        if (visibleCell != nil) {
                            [sectionController configureCell:visibleCell at:k];
                        }
                    }
                    
                    // Reuse the previous section controller
                    dict[@(j)] = sectionController;
                    delete = false;
                    newSectionIndex = j + 1;
                    break;
                }
            }
            // If the section has the same identifier, reuse the previous cell
            // TODO: Handle section count changes
            else if ([prevIdentifier isEqual:currIdentifier]) {
                id<LYSectionController> sectionController = sections[j].newSectionController;
                // And if the new section controller supports configuring cells
                if ([sectionController respondsToSelector:@selector(configureCell:at:)]) {
                    // Set up the new section controller
                    [sectionController setDelegate:self];
                    [sectionController setup];

                    // Configure all of the visible cells with the new section controller
                    NSInteger count = [sectionController respondsToSelector:@selector(count)] ? sectionController.count : 1;
                    for (NSInteger k = 0; k < count; k++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:k inSection:i];
                        UICollectionViewCell *visibleCell = [_collectionView cellForItemAtIndexPath:indexPath];
                        if (visibleCell != nil) {
                            [sectionController configureCell:visibleCell at:k];
                        }
                    }
                    
                    // Use the new section controller
                    dict[@(j)] = sectionController;
                    delete = false;
                    newSectionIndex = j + 1;
                    break;
                }
            }
        }
        
        // Mark any previous section that was not reused to be deleted
        if (delete) {
            [indexesToDelete addIndex:i];
        }
    }
    
    _sections = sections;
    
    // For each new section
    NSMutableArray *sectionControllers = [NSMutableArray array];
    for (NSInteger i = 0; i < _sections.count; i++) {
        // If we didn't reuse/create a section controller above
        id<LYSection> section = _sections[i];
        id<LYSectionController> sectionController = dict[@(i)];
        if (sectionController == nil) {
            // Create a section controller now
            sectionController = [section newSectionController];
            [sectionController setDelegate:self];
            [sectionController setup];
            [indexesToAdd addIndex:i];
        }
        [sectionControllers addObject:sectionController];
    }
    
    // Don't animate the initial set of cells. Also if the cells have not loaded in yet, sometimes performBatchUpdates
    // will reloadData before the block with the previous sectionControllers, and not use the updated sectionControllers.
    if ([_collectionView visibleCells].count != 0) {
        [_collectionView performBatchUpdates:^{
            _sectionControllers = sectionControllers;
            [_collectionView deleteSections:indexesToDelete];
            [_collectionView insertSections:indexesToAdd];
        } completion:nil];
    } else {
        _sectionControllers = sectionControllers;
        [_collectionView reloadData];
    }
}

@end
