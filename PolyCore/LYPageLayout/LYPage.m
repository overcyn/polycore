//
//  LYPage.m
//  GitApp
//
//  Created by Kevin Dang on 3/22/20.
//  Copyright © 2020 Overcyn. All rights reserved.
//

#import "LYPage.h"

@implementation LYPageInput
@end

@implementation LYPageOutput

- (id)init {
    if ((self = [super init])) {
//        self.preferredStatusBarStyle = UIStatusBarStyleDefault;
        self.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
        self.leftItemsSupplementBackButton = true;
        self.hidesBackButton = false;
        self.hidesNavigationBar = false;
        self.scrollEnabled = true;
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
