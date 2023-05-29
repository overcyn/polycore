#import "LYCollectionViewLayout.h"
#import "LYCollectionViewBehavior.h"
#import "LYCollectionViewCustomBehavior.h"
#import "UIKit+LYAdditions.h"

@implementation LYCollectionViewLayout {
    CGSize _sizeAtSetup;
    BOOL _valid;
    CGSize _contentSize;
    NSArray<id<LYCollectionViewBehavior>> *_behaviorArray;
    NSArray<NSArray<LYCollectionViewLayoutAttributes *> *> *_attributesArray;
    NSArray<LYCollectionViewLayoutAttributes *> *_flattenedAttributesArray;
    LYDefaultBehavior *_defaultBehavior;
    LYCollectionViewBehaviorInput *_cachedInputObject;
}

+ (Class)layoutAttributesClass {
    return [LYCollectionViewLayoutAttributes class];
}

- (id)init {
    if ((self = [super init])) {
        _defaultBehavior = [[LYDefaultBehavior alloc] init];
        _cachedInputObject = [[LYCollectionViewBehaviorInput alloc] init];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    if (!CGSizeEqualToSize([[self collectionView] frame].size, _sizeAtSetup)) {
        _valid = NO;
    }
    if (!_valid) {
        [self _setup];
    }
    [self _updateAttributes];
}

- (CGSize)collectionViewContentSize {
    return _contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributesArray = [NSMutableArray array];
    for (LYCollectionViewLayoutAttributes *i in _flattenedAttributesArray) {
        if (CGRectIntersectsRect(i->optimizedFrame, rect)) {
            [attributesArray addObject:i];
        }
    }
    return attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _attributesArray[[indexPath section]][[indexPath item]];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context {
    [super invalidateLayoutWithContext:context];
    if ([context invalidateEverything] || [context invalidateDataSourceCounts]) {
        _valid = NO;
    }
}

#pragma mark - Internal

- (void)_setup {
    UICollectionView *view = [self collectionView];
    CGSize size = [view frame].size;
    id<UICollectionViewDataSource> dataSource = [view dataSource];
    id<LYCollectionViewDelegateLayout> delegate = (id)[view delegate];
    NSInteger sections = [dataSource numberOfSectionsInCollectionView:view];
    LYCollectionViewBehaviorInput *input = _cachedInputObject;
    [input setCollectionView:view];
    [input setLayout:self];
    [input setContext:[[NSMutableDictionary alloc] init]];
    
    CGFloat y = 0;
    UIEdgeInsets scrollIndicatorInsets = UIEdgeInsetsZero;
    NSMutableArray *behaviorArray = [NSMutableArray array];
    NSMutableArray *attributesArray = [NSMutableArray array];
    NSMutableArray *flattenedAttributesArray = [NSMutableArray array];
    for (NSInteger i = 0; i < sections; i++) {
        id<LYCollectionViewBehavior> sectionBehavior = [delegate collectionView:view layout:self behaviorForSectionAtIndex:i] ?: _defaultBehavior;
        [behaviorArray addObject:sectionBehavior];
        [input setSection:i];
        [input setY:y];
        [input setScrollIndicatorInsets:scrollIndicatorInsets];
        
        LYCollectionViewBehaviorOutput *output = [sectionBehavior getAttributes:input];
        [attributesArray addObject:[output attributes]];
        [flattenedAttributesArray addObjectsFromArray:[output attributes]];
        y += [output height];
        scrollIndicatorInsets.top += [output scrollIndicatorInsets].top;
        scrollIndicatorInsets.bottom += [output scrollIndicatorInsets].bottom;
    }
    
    _contentSize = CGSizeMake(size.width, y);
    _attributesArray = attributesArray;
    _flattenedAttributesArray = flattenedAttributesArray;
    _behaviorArray = behaviorArray;
    _sizeAtSetup = size;
    _valid = YES;
    [view setScrollIndicatorInsets:scrollIndicatorInsets];
}

- (void)_updateAttributes {
    UICollectionView *collectionView = [self collectionView];
    NSInteger numberOfSections = [collectionView numberOfSections];
    LYCollectionViewBehaviorInput *input = _cachedInputObject; // collectionView and layout properties are already set in _setup.
    [input setContext:[[NSMutableDictionary alloc] init]];
    for (NSInteger i = 0; i < numberOfSections; i++) {
        id<LYCollectionViewBehavior> sectionBehavior = _behaviorArray[i];
        if (sectionBehavior != _defaultBehavior) {
            [input setSection:i];
            [sectionBehavior updateAttributes:_attributesArray[i] withInput:input];
        }
    }
}

@end

@implementation LYCollectionViewLayoutAttributes

- (id)copyWithZone:(NSZone *)zone {
    LYCollectionViewLayoutAttributes *copy = [super copyWithZone:zone];
    [copy setOffset:[self offset]];
    copy->optimizedFrame = self->optimizedFrame;
    return copy;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self->optimizedFrame = frame;
}

@end
