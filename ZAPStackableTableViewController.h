//
//  ZAStackableTableViewController.h
//  Sous Vide Celsius
//
//  Created by Stefan Pauwels on 02.05.14.
//  Copyright (c) 2014 Artisan Cuisinier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZAPStackViewContainer.h"

@interface ZAPStackableTableViewController : UITableViewController <ZAPStackableViewController>

@property (nonatomic, weak) ZAPStackViewContainer *viewStack;
@property (nonatomic, assign) int stackPosition;
@property (nonatomic, assign) BOOL stretch;
@property (nonatomic, assign) CGFloat desiredWidth;
@property (nonatomic, assign) BOOL slidable;
@property (nonatomic, assign) BOOL alwaysCastsShadow;
@property (nonatomic, assign) CGFloat minVisibleWidth;

@end
