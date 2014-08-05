//
//  FlickrEffectViewController.h
//  FlickrEffect
//
//  Created by A38315 on 8/4/14.
//  Copyright (c) 2014 Claudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrEffectViewController : UIViewController<UIScrollViewDelegate>

#define REFRESH_HEADER_HEIGHT 52.0f

@property(nonatomic, weak)IBOutlet UIScrollView *myScrolView;
@property(nonatomic, strong)UIImageView *myImageView;
@property(nonatomic, strong)UIView *underCircle;

@property(nonatomic)BOOL isDragging;
@property(nonatomic)BOOL isLoading;
@property(nonatomic)BOOL isAnimating;

@end
