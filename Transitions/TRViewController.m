//
//  TRViewController.m
//  Transitions
//
//  Created by jbaek on 4/2/14.
//  Copyright (c) 2014 baek. All rights reserved.
//

#import "TRViewController.h"

#define TOTAL_ANIMATION_DURATION 1.2
#define DELTA_X_OFF_OF_SCREEN 50
#define ARBRITARY_LARGE_NUMBER 1073741824

@interface TRViewController ()

{
    @private
    NSArray *_labels;
    NSArray *_colours;
    
    NSInteger colourIndex;
    NSInteger labelIndex;
}

@end

@implementation TRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect firstLabelRectangle = CGRectMake(0, 0, 40, 40);
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:firstLabelRectangle];
    firstLabel.center = self.view.center;
    firstLabel.text = @"Hello";
    [self.view addSubview:firstLabel];
    
    CGRect subsequentLabelRectangle = firstLabel.frame;
    subsequentLabelRectangle.origin.x = CGRectGetMaxX(self.view.frame) + DELTA_X_OFF_OF_SCREEN;
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:subsequentLabelRectangle];
    secondLabel.text = @"Hi";
    [self.view addSubview:secondLabel];
    
    UILabel *thirdLabel = [[UILabel alloc] initWithFrame:subsequentLabelRectangle];
    thirdLabel.text = @"Hey";
    [self.view addSubview:thirdLabel];

    _labels = [NSArray arrayWithObjects:firstLabel, secondLabel, thirdLabel, nil];
    
    
    UIColor *firstColor = [UIColor greenColor];
    UIColor *secondColor = [UIColor blueColor];
    UIColor *thirdColor = [UIColor magentaColor];
    self.view.backgroundColor = thirdColor;
    
    _colours = [NSArray arrayWithObjects:firstColor, secondColor, thirdColor, nil];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    colourIndex = -1;
    labelIndex = -1;
    [NSTimer scheduledTimerWithTimeInterval:3.5
                                     target:self
                                   selector:@selector(transitionAnimation)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)transitionAnimation;
{
    colourIndex++;
    labelIndex++;
    if (colourIndex == [_colours count]) {
        colourIndex = 0;
    }
    if (labelIndex == [_labels count]) {
        labelIndex = 0;
    }
    
    [UIView animateWithDuration:TOTAL_ANIMATION_DURATION animations:^{
        self.view.backgroundColor = [_colours objectAtIndex:colourIndex];
    }];
    [UIView animateWithDuration:(TOTAL_ANIMATION_DURATION/2) animations:^{
        UILabel *displayedLabel = (UILabel*)[_labels objectAtIndex:labelIndex];
        CGRect oldRectangle = displayedLabel.frame;
        oldRectangle.origin.x = -DELTA_X_OFF_OF_SCREEN;
        displayedLabel.frame = oldRectangle;

    } completion:^(BOOL finished){
        [UIView animateWithDuration:(TOTAL_ANIMATION_DURATION/2) animations:^{
            UILabel *nextLabel = (UILabel*)[_labels objectAtIndex:(labelIndex + 1) % [_labels count]];
            nextLabel.center = self.view.center;
        } completion:^(BOOL finished){
            UILabel *justDisappearedLabel = (UILabel*)[_labels objectAtIndex:labelIndex];
            CGRect oldRectangle = justDisappearedLabel.frame;
            oldRectangle.origin.x = CGRectGetMaxX(self.view.frame) + DELTA_X_OFF_OF_SCREEN;
            justDisappearedLabel.frame = oldRectangle;
        }];
    }];
}
@end
