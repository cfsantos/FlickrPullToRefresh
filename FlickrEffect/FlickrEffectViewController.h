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

#define MINORSCALE 0.25
#define MAJORSCALE 1/MINORSCALE
#define LEFTLIMIT 140
#define RIGHTLIMIT 190
#define CIRCLECENTERX 160
#define CIRCLECENTERY 100



@property(nonatomic, weak)IBOutlet UIScrollView *myScrolView;
@property(nonatomic, strong)UIImageView *myImageView;
@property(nonatomic, strong)UIImageView *faceImageView;
@property(nonatomic, strong)UIImage *downloadedImage;


@property(nonatomic, strong)UIView *underCircle;
@property(nonatomic, strong)UIView *pinkCircle;

@property(nonatomic)BOOL isDragging;
@property(nonatomic)BOOL isLoading;
@property(nonatomic)BOOL isAnimating;
@property(nonatomic)BOOL shouldAnimate;
@property(nonatomic)BOOL isDownloadFinished;



@end
