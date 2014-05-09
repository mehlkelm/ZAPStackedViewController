//
//  ZAStackedViewContainer.h
//  Celsius
//
//  Created by Stefan Pauwels on 07.06.11.
//  Copyright 2011 Zozi Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultMinVisibleWidth 60.0f

@class ZAPStackViewContainer;

@protocol ZAPStackableViewController <NSObject>

- (ZAPStackViewContainer *)viewStack;
- (void)setViewStack:(ZAPStackViewContainer *)viewStack;

- (int)stackPosition;
- (void)setStackPosition:(int)position;

- (BOOL)stretch;
- (void)setStretch:(BOOL)stretch;

- (CGFloat)desiredWidth;
- (void)setDesiredWidth:(CGFloat)desiredWidth;

- (BOOL)slidable;
- (void)setSlidable:(BOOL)slidable;

- (BOOL)alwaysCastsShadow;
- (void)setAlwaysCastsShadow:(BOOL)alwayCastsShadow;

- (CGFloat)minVisibleWidth;
- (void)setMinVisibleWidth:(CGFloat)minVisibleWidth;

@optional
- (void)didBecomeTopViewController;

@end

@interface ZAPStackViewContainer : UIViewController <UIGestureRecognizerDelegate> {
    
    CGRect _slidableViewFrameCache;
}

@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) UINavigationBar *navigationBar;

- (void)pushViewController:(UIViewController <ZAPStackableViewController> *)viewController animated:(BOOL)animated;
- (void)setViewController:(UIViewController <ZAPStackableViewController> *)viewController atPosition:(int)position animated:(BOOL)animated;
- (void)replaceViewControllerAtPosition:(int)position with:(UIViewController <ZAPStackableViewController> *)viewController animated:(BOOL)animated;
- (void)popViewControllersDownTo:(NSUInteger)remainingControllerCount animated:(BOOL)animated;
- (void)popViewControllers:(NSUInteger)numberOfControllersToPop animated:(BOOL)animated;
- (void)popViewControllerAnimated:(BOOL)animated;
- (void)layoutViewsAnimated:(BOOL)animated;
- (CGFloat)cumulativeViewWidth;
- (CGFloat)cumulativeViewWidthUpToPosition:(NSUInteger)position;

@end
