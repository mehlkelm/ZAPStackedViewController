//
//  ZAStackableViewController.m
//  Feed Filter
//
//  Created by Stefan Pauwels on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZAStackableViewController.h"

@interface ZAStackableViewController ()

@end

@implementation ZAStackableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.minVisibleWidth = kDefaultMinVisibleWidth;
    }
    return self;
}

@end
