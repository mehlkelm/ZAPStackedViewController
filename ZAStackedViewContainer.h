//
//  ZAStackedViewContainer.h
//  Celsius
//
//  Created by Stefan Pauwels on 07.06.11.
//  Copyright 2011 Eat This. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultMinVisibleWidth 60.0f

@class ZAStackedViewContainer;

@protocol ZAStackableViewController <NSObject>

- (ZAStackedViewContainer *)viewStack;
- (void)setViewStack:(ZAStackedViewContainer *)viewStack;

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

@interface ZAStackedViewContainer : UIViewController <UIGestureRecognizerDelegate> {
    
    CGRect _slidableViewFrameCache;
}

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) UINavigationBar *navigationBar;

- (void)pushViewController:(UIViewController <ZAStackableViewController> *)viewController animated:(BOOL)animated;
- (void)setViewController:(UIViewController <ZAStackableViewController> *)viewController atPosition:(int)position animated:(BOOL)animated;
- (void)replaceViewControllerAtPosition:(int)position with:(UIViewController <ZAStackableViewController> *)viewController animated:(BOOL)animated;
- (void)popViewControllersDownTo:(NSUInteger)remainingControllerCount animated:(BOOL)animated;
- (void)popViewControllers:(NSUInteger)numberOfControllersToPop animated:(BOOL)animated;
- (void)popViewControllerAnimated:(BOOL)animated;
- (void)layoutViewsAnimated:(BOOL)animated;
- (CGFloat)cumulativeViewWidth;
- (CGFloat)cumulativeViewWidthUpToPosition:(NSUInteger)position;

@end
