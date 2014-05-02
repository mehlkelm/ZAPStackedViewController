//
//  ZAStackableTableViewController.m
//  Sous Vide Celsius
//
//  Created by Stefan Pauwels on 02.05.14.
//  Copyright (c) 2014 Artisan Cuisinier. All rights reserved.
//

#import "ZAPStackableTableViewController.h"

@interface ZAPStackableTableViewController ()

@end

@implementation ZAPStackableTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
