//
//  ZAStackableViewController.m
//  Feed Filter
//
//  Created by Stefan Pauwels on 04.06.12.
//  Copyright (c) 2012 Zozi Apps. All rights reserved.
//

#import "ZAPStackableViewController.h"

@interface ZAPStackableViewController ()

@end

@implementation ZAPStackableViewController

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
