//
//  ZAStackedViewContainer.m
//  Celsius
//
//  Created by Stefan Pauwels on 07.06.11.
//  Copyright 2011 Zozi Apps. All rights reserved.
//

#import "ZAPStackViewContainer.h"
#import <QuartzCore/QuartzCore.h>
#import "ZAStackableViewGestureRecognizer.h"

#define kDefaultNavBarHeight 44.0f
#define kStackableViewWidth 320.f
//#define kBorderViewTag 777

@implementation ZAPStackViewContainer

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *vcs = self.viewControllers;
    self.viewControllers = [[NSMutableArray alloc] initWithCapacity:[vcs count]];
    
    for (UIViewController <ZAPStackableViewController> *viewController in vcs) {
        [self pushViewController:viewController animated:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self layoutViewsAnimated:animated];
}


# pragma mark - View Stacking Stuff

- (void)pushViewController:(UIViewController <ZAPStackableViewController> *)viewController animated:(BOOL)animated
{
    // TODO: Is it safe to call this externally
    CGFloat desiredWidth = viewController.desiredWidth;
    if (! (desiredWidth > 0)) {
        viewController.desiredWidth = viewController.view.frame.size.width;
    }

    NSUInteger position = [self.viewControllers count];
    [viewController setViewStack:self];
    [viewController setStackPosition:(int)position];
    viewController.view.layer.masksToBounds = NO;

    ZAPStackableViewPanGestureRecognizer *panRec = [[ZAPStackableViewPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panRec.stackPosition = position;
    panRec.delegate = self;
    [viewController.view addGestureRecognizer:panRec];

    CGFloat xOrigin = 0.0f;
    if (position > 0) {
        xOrigin = self.view.bounds.size.width;
    }
    CGRect animationStartFrame = CGRectMake(xOrigin, 0.0f, [viewController desiredWidth], self.view.bounds.size.height);
    viewController.view.frame = animationStartFrame;
    [self addChildViewController:viewController];
    [self.viewControllers addObject:viewController];
    [self addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    [self layoutViewsAnimated:animated];
    
    viewController.navigationItem.hidesBackButton = YES;
    [self.navigationBar pushNavigationItem:viewController.navigationItem animated:animated];
}

- (void)setViewController:(UIViewController <ZAPStackableViewController> *)viewController atPosition:(int)position animated:(BOOL)animated {
    
    CGFloat desiredWidth = viewController.desiredWidth;
    if (! (desiredWidth > 0)) {
        viewController.desiredWidth = viewController.view.frame.size.width;
    }
    
    if (position >= [self.viewControllers count]) {
        [self pushViewController:viewController animated:animated];
    } else {
        [self replaceViewControllerAtPosition:position with:viewController animated:animated];
        [self popViewControllersDownTo:(position + 1) animated:YES];
    }
}

- (void)popViewControllersDownTo:(NSUInteger)remainingControllerCount animated:(BOOL)animated
{
    if ([self.viewControllers count] > remainingControllerCount) {
        NSUInteger popCount = [self.viewControllers count] - remainingControllerCount;
        [self popViewControllers:popCount animated:animated];
    } else {
        [self popViewControllers:0 animated:animated];
    }
}

- (void)popViewControllers:(NSUInteger)numberOfControllersToPop animated:(BOOL)animated
{
    for (int i = 0; i < numberOfControllersToPop; i++) {
        //TODO: Als eine zusammenhängende Animation, mit layoutviews als completion
        [self popViewControllerWithoutLayoutAnimated:animated];
    }
    UIViewController<ZAPStackableViewController> *topController = [self.viewControllers lastObject];
    if (numberOfControllersToPop > 0 && [topController respondsToSelector:@selector(didBecomeTopViewController)]) {
        [topController didBecomeTopViewController];
    }
    [self layoutViewsAnimated:animated];
}

- (void)popViewControllerAnimated:(BOOL)animated
{
    [self popViewControllers:1 animated:animated];
}

- (void)popViewControllerWithoutLayoutAnimated:(BOOL)animated
{
    UIViewController *popIt;
    if ([self.viewControllers count] > 0) {
        popIt = [self.viewControllers lastObject];
        CGRect animationEndFrame = CGRectMake(self.view.bounds.size.width,
                   0.0f,
                   popIt.view.frame.size.width,
                   popIt.view.frame.size.height);
        void (^animations)(void) = ^{
            popIt.view.frame = animationEndFrame;
        };
        void (^completions)(BOOL) = ^(BOOL finished){
            [popIt willMoveToParentViewController:nil];
            [popIt.view removeFromSuperview];
        };
        if (animated) {
            [UIView animateWithDuration:0.2 animations:animations completion:completions];            
        } else {
            animations();
            completions(YES);
        }
        [popIt removeFromParentViewController];
        [self.viewControllers removeLastObject];
        [self.navigationBar popNavigationItemAnimated:animated];
    }
}

- (void)replaceViewControllerAtPosition:(int)position with:(UIViewController <ZAPStackableViewController> *)viewController animated:(BOOL)animated
{
    if ([self.viewControllers count] <= position) return;
    
    CGFloat desiredWidth = viewController.desiredWidth;
    if (! (desiredWidth > 0)) {
        viewController.desiredWidth = viewController.view.frame.size.width;
    }
    
    ZAPStackableViewPanGestureRecognizer *panRec = [[ZAPStackableViewPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panRec.stackPosition = position;
    panRec.delegate = self;
    [viewController.view addGestureRecognizer:panRec];
    
    UIViewController <ZAPStackableViewController> *oldVc = (UIViewController <ZAPStackableViewController> *) [self.viewControllers objectAtIndex:position];
    if (oldVc == viewController) return;

    [viewController setViewStack:self];
    [viewController setStackPosition:position];
    
    viewController.view.frame = oldVc.view.frame;
    [oldVc willMoveToParentViewController:nil];
    [self addChildViewController:viewController];
    [self.viewControllers replaceObjectAtIndex:position withObject:viewController];

    if (animated) {
        UIViewAnimationOptions animationOption = UIViewAnimationOptionTransitionCrossDissolve;
        [UIView transitionFromView:oldVc.view toView:viewController.view duration:0.2f options:animationOption completion:^(BOOL finished){
            [oldVc removeFromParentViewController];
            [viewController didMoveToParentViewController:self];
        }];
    } else {
        [self addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        [oldVc.view removeFromSuperview];
        [oldVc removeFromParentViewController];
    }

    /* Manage Navigation Items */
    viewController.navigationItem.hidesBackButton = YES;
    NSMutableArray *navigationItems = [[self.navigationBar items] mutableCopy];
    [navigationItems replaceObjectAtIndex:position withObject:viewController.navigationItem];
    [self.navigationBar setItems:navigationItems animated:NO];
}

- (CGFloat)cumulativeViewWidth
{
    return [self cumulativeViewWidthUpToPosition:([self.viewControllers count] - 1)];
}


- (CGFloat)cumulativeViewWidthUpToPosition:(NSUInteger)position
{
    CGFloat totalWidth = 0.0f;
    int count = (int)[self.viewControllers count];
    for (NSUInteger v = 0; v <= position && v < count; v++) {
        UIViewController <ZAPStackableViewController> *viewController = [self.viewControllers objectAtIndex:v];
        totalWidth += [viewController desiredWidth];
    }
    return totalWidth;
}

- (void)layoutViewsAnimated:(BOOL)animated
{
    CGFloat cumulativeWidth = [self cumulativeViewWidth];
    CGFloat availableWidth = self.view.bounds.size.width;
    NSUInteger controllerCount = [self.viewControllers count];
    
    // Layout root view
    if ([self.viewControllers count] > 0) {
        UIViewController <ZAPStackableViewController> *rootViewController = (UIViewController <ZAPStackableViewController> *) [self.viewControllers objectAtIndex:0];
        
        CGFloat width = MIN([rootViewController desiredWidth], availableWidth);
        CGRect newFrame = CGRectMake(0.0f, 0.0f, width, self.view.bounds.size.height);
        
        void (^animations)(void) = ^{
            rootViewController.view.frame = newFrame;
        };
        if (animated) {
            [UIView animateWithDuration:0.2 animations:animations completion:nil];
        } else {
            animations();
        }
    }
    
    if (cumulativeWidth <= availableWidth) {
        //NSLog(@"Views can be laid without overlap");

        for (NSUInteger pos = 0; pos < controllerCount; pos++) {
            UIViewController <ZAPStackableViewController> *vc = [self.viewControllers objectAtIndex:pos];
            
            CGFloat viewWidth = [vc desiredWidth];
            CGFloat xOrigin = 0.0f;
            if (pos > 0) {
                UIViewController *parent = [self.viewControllers objectAtIndex:pos - 1];
                xOrigin = parent.view.frame.origin.x + parent.view.frame.size.width;
            }

            if ([vc stretch] && pos == controllerCount - 1) {
                viewWidth = MAX([vc desiredWidth], availableWidth - xOrigin);
            }
            CGRect newFrame = CGRectMake(xOrigin, 0.0f, viewWidth, self.view.bounds.size.height);
            //NSLog(@"VC %lu: %@", (unsigned long)pos, NSStringFromCGRect(newFrame));
            vc.view.layer.shadowPath = nil;
            void (^animations)(void) = ^{
                vc.view.frame = newFrame;
            };
            void (^completion)(BOOL) = ^(BOOL finished){
                if (vc.alwaysCastsShadow && pos > 0) {
                    vc.view.clipsToBounds = NO;
                    vc.view.layer.shadowOffset = CGSizeMake(-2.0f, 0.0f);
                    vc.view.layer.shadowRadius = 0.5f;
                    vc.view.layer.shadowOpacity = 0.3f;
                    vc.view.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
                    vc.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:vc.view.bounds].CGPath;
//                    [[vc.view viewWithTag:kBorderViewTag] removeFromSuperview];
                }
                else {
                    vc.view.clipsToBounds = YES;
                    vc.view.layer.shadowOffset = CGSizeZero;
                    vc.view.layer.shadowRadius = 0.0f;
                    vc.view.layer.shadowOpacity = 0.0f;
                    // overSlider.view.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
                    vc.view.layer.shadowPath = nil;
                    
//                    UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.0f, newFrame.size.height)];
//                    border.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
//                    border.tag = kBorderViewTag;
//                    [vc.view addSubview:border];
                }
            };
            
            if (animated) {
                [UIView animateWithDuration:0.2 animations:animations completion:completion];
            } else {
                animations();
                completion(YES);
            }
        }
    } else {
        //NSLog(@"Views have to overlap");
        CGFloat neededOverlap = cumulativeWidth - availableWidth;
        CGFloat neededOverlapRemaining = neededOverlap;
        CGFloat currentOverlap = 0.0f;
        
        for (NSUInteger pos = 1; pos < controllerCount; pos++) {
            
            UIViewController <ZAPStackableViewController> *underSlider = [self.viewControllers objectAtIndex:(pos - 1)];
            UIViewController <ZAPStackableViewController> *overSlider = (UIViewController <ZAPStackableViewController> *) [self.viewControllers objectAtIndex:pos];
            
            CGFloat thisStepsMaxOverlap = [underSlider desiredWidth] - underSlider.minVisibleWidth;
            CGFloat thisStepsOverlap = MIN(neededOverlapRemaining, thisStepsMaxOverlap);
            
            CGFloat xOrigin = underSlider.view.frame.origin.x + [underSlider desiredWidth] - thisStepsOverlap;
            CGFloat width = MIN([overSlider desiredWidth], availableWidth - xOrigin);
            // if ([overSlider stretch]) {
            //   width = MAX(width, availableWidth - xOrigin);
            // }
            underSlider.view.layer.shadowPath = nil;
            overSlider.view.layer.shadowPath = nil;
            CGRect newFrame = CGRectMake(xOrigin, 0.0f, width, self.view.bounds.size.height);
            NSLog(@"VC %lu: %@", (unsigned long)pos, NSStringFromCGRect(newFrame));
            void (^animations)(void) = ^{
                overSlider.view.frame = newFrame;
            };
            void (^completion)(BOOL) = ^(BOOL finished){
                if (thisStepsOverlap > 0 || overSlider.alwaysCastsShadow) {
                    overSlider.view.clipsToBounds = NO;
                    overSlider.view.layer.shadowOffset = CGSizeMake(-2.0f, 0.0f);
                    overSlider.view.layer.shadowRadius = 0.5f;
                    overSlider.view.layer.shadowOpacity = 0.3f;
                    overSlider.view.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
                    overSlider.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:overSlider.view.bounds].CGPath;
//                    [[overSlider.view viewWithTag:kBorderViewTag] removeFromSuperview];
                } else {
                    overSlider.view.clipsToBounds = YES;
                    overSlider.view.layer.shadowOffset = CGSizeZero;
                    overSlider.view.layer.shadowRadius = 0.0f;
                    overSlider.view.layer.shadowOpacity = 0.0f;
                    // overSlider.view.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
                    overSlider.view.layer.shadowPath = nil;
                    
//                    UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.0f, newFrame.size.height)];
//                    border.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
//                    border.tag = kBorderViewTag;
//                    [overSlider.view addSubview:border];
                }
            };
                        
            if (animated) {
                [UIView animateWithDuration:0.2 animations:animations completion:completion];
            } else {
                animations();
                completion(YES);
            }
            
            currentOverlap += thisStepsOverlap;
            neededOverlapRemaining -= thisStepsOverlap;
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[ZAPStackableViewPanGestureRecognizer class]]) {
        ZAPStackableViewPanGestureRecognizer *panRec = (ZAPStackableViewPanGestureRecognizer *)gestureRecognizer;
        
        NSUInteger pos = panRec.stackPosition;
        if ([self.viewControllers count] <= pos) return NO;
        
        UIViewController <ZAPStackableViewController> *viewController = [self.viewControllers objectAtIndex:pos];
        if (!viewController.slidable) return NO;
        
        CGPoint translation = [panRec translationInView:self.view];
        if (translation.x > 3 * ABS(translation.y)) return YES;
        if (translation.x < -3 * ABS(translation.y)) return YES;
    }
    return NO;
}

- (void)handlePanGesture:(ZAPStackableViewPanGestureRecognizer *)sender {
    
    NSUInteger viewCount = [self.viewControllers count];
    NSUInteger pos = sender.stackPosition;
    UIViewController <ZAPStackableViewController> *viewController = [self.viewControllers objectAtIndex:pos];
    
    if ([sender velocityInView:self.view].x >= 1111) {
        [self popViewControllersDownTo:pos animated:YES]; // The dragged view could be not the one on top
        [sender removeTarget:self action:NULL];
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        _slidableViewFrameCache = sender.view.frame;
    }
    
    CGPoint translation = [sender translationInView:self.view];

    if (translation.x >= - 23) {
        CGRect frame = _slidableViewFrameCache;
        frame.origin.x += translation.x;
        sender.view.frame = frame;
        // The dragged view could be not the one on top
        for (int i = (int)pos + 1; i < viewCount; i++) {
            UIViewController <ZAPStackableViewController> *higherViewController = [self.viewControllers objectAtIndex:i];
            CGRect higherFrame = higherViewController.view.frame;
            if (frame.origin.x > higherFrame.origin.x - (i - pos) * viewController.minVisibleWidth) {
                higherFrame.origin.x = frame.origin.x + (i - pos) * viewController.minVisibleWidth;
                higherViewController.view.frame = higherFrame;
                viewController = higherViewController;
            }
        }
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (translation.x >= sender.view.bounds.size.width / 3) {
            [self popViewControllersDownTo:pos animated:YES];
        } else {
            [self layoutViewsAnimated:YES];
        }
    }
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self layoutViewsAnimated:YES];
}

- (void)addSubview:(UIView *)view
{
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:view];
}

@end
