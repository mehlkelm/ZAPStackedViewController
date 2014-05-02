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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.minVisibleWidth = kDefaultMinVisibleWidth;
    }
    return self;
}

@end
