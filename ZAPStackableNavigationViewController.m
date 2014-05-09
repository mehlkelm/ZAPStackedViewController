//
//  ZAPStackableNavigationViewController.m
//  Sous Vide Celsius
//
//  Created by Stefan Pauwels on 09.05.14.
//  Copyright (c) 2014 Artisan Cuisinier. All rights reserved.
//

#import "ZAPStackableNavigationViewController.h"

@interface ZAPStackableNavigationViewController ()

@end

@implementation ZAPStackableNavigationViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass
{
    self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.minVisibleWidth = kDefaultMinVisibleWidth;
}

@end
