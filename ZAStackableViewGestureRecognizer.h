//
//  FFStackableViewPanGestureRecognizer.h
//  Feed Filter
//
//  Created by Stefan Pauwels on 29.07.12.
//
//

#import <UIKit/UIKit.h>

@interface ZAPStackableViewPanGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, assign) NSUInteger stackPosition;

@end