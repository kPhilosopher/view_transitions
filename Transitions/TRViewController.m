//
//  TRViewController.m
//  Transitions
//
//  Created by jbaek on 4/2/14.
//  Copyright (c) 2014 baek. All rights reserved.
//

#import "TRViewController.h"

#define NUMBER_OF_TRANSITIONS 3
#define TOTAL_ANIMATION_DURATION 1.2
#define ANIMATION_START_X_COORDINATE 50

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
    subsequentLabelRectangle.origin.x = CGRectGetMaxX(self.view.frame) + ANIMATION_START_X_COORDINATE;
    
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
                                   selector:@selector(startTransitioning)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)startTransitioning;
{
    colourIndex++;
    labelIndex++;
    [UIView animateWithDuration:TOTAL_ANIMATION_DURATION animations:^{
        self.view.backgroundColor = [_colours objectAtIndex:colourIndex % NUMBER_OF_TRANSITIONS];
    }];
    [UIView animateWithDuration:(TOTAL_ANIMATION_DURATION/2) animations:^{
        UILabel *currentlyDisplayingLabel = (UILabel*)[_labels objectAtIndex:labelIndex % NUMBER_OF_TRANSITIONS];
        CGRect oldRectangle = currentlyDisplayingLabel.frame;
        oldRectangle.origin.x = -ANIMATION_START_X_COORDINATE;
        currentlyDisplayingLabel.frame = oldRectangle;

    } completion:^(BOOL finished){
        [UIView animateWithDuration:(TOTAL_ANIMATION_DURATION/2) animations:^{
            UILabel *nextLabel = (UILabel*)[_labels objectAtIndex:(labelIndex + 1) % NUMBER_OF_TRANSITIONS];
            nextLabel.center = self.view.center;
        } completion:^(BOOL finished){
            UILabel *justDisappearedLabel = (UILabel*)[_labels objectAtIndex:labelIndex % NUMBER_OF_TRANSITIONS];
            CGRect oldRectangle = justDisappearedLabel.frame;
            oldRectangle.origin.x = CGRectGetMaxX(self.view.frame) + ANIMATION_START_X_COORDINATE;
            justDisappearedLabel.frame = oldRectangle;
        }];
    }];
}
@end
