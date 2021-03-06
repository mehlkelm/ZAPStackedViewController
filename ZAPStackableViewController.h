//
//  ZAStackableViewController.h
//  Feed Filter
//
//  Created by Stefan Pauwels on 04.06.12.
//  Copyright (c) 2012 Zozi Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZAPStackViewContainer.h"

@interface ZAPStackableViewController : UIViewController <ZAPStackableViewController>

@property (nonatomic, weak) ZAPStackViewContainer *viewStack;
@property (nonatomic, assign) int stackPosition;
@property (nonatomic, assign) BOOL stretch;
@property (nonatomic, assign) CGFloat desiredWidth;
@property (nonatomic, assign) BOOL slidable;
@property (nonatomic, assign) BOOL alwaysCastsShadow;
@property (nonatomic, assign) CGFloat minVisibleWidth;

@end
