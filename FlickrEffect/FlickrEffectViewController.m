//
//  FlickrEffectViewController.m
//  FlickrEffect
//
//  Created by A38315 on 8/4/14.
//  Copyright (c) 2014 Claudio. All rights reserved.
//

#import "FlickrEffectViewController.h"

@interface FlickrEffectViewController ()

@end

@implementation FlickrEffectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.shouldAnimate = YES;
    self.isAnimating = FALSE;
    self.myScrolView.delegate = self;
    self.myScrolView.contentSize = CGSizeMake(320, 4000);
    
    self.myImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"garden.jpg"]];
    self.myImageView.frame = CGRectMake(0, 0, 320, 200);
    [self.myScrolView addSubview:self.myImageView];
    
    self.pinkCircle = [[UIView alloc] initWithFrame:CGRectMake(110, 50, 100, 100)];

    
    self.underCircle = [[UIView alloc] initWithFrame:CGRectMake(110, 50, 100, 100)];
    CAShapeLayer *shape = [CAShapeLayer layer];
    UIBezierPath *path;
    
    path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50)
                                          radius:50
                                      startAngle:0
                                        endAngle:(2 * M_PI)
                                       clockwise:YES];
    shape.path = path.CGPath;
    self.underCircle.layer.mask = shape;
    
    self.pinkCircle.layer.mask = shape;
    self.pinkCircle.backgroundColor = [UIColor clearColor];
    self.underCircle.backgroundColor = [UIColor clearColor];
    
    [self.myImageView addSubview:self.underCircle];
    [self.myImageView addSubview:self.pinkCircle];
    
    [self startLoading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat newScale = 1 + ((scrollOffset * -1) / 200);
    CGFloat y = -(scrollView.contentOffset.y);
    
    if (scrollView.contentOffset.y < 1){
        CGAffineTransform scale = CGAffineTransformMakeScale(newScale, newScale);

        self.myImageView.transform = scale;
        self.myImageView.frame = CGRectMake(self.myImageView.frame.origin.x, scrollOffset, self.myImageView.frame.size.width, self.myImageView.frame.size.height);
        if (self.shouldAnimate) {
            [self drawUnderCircleForOffset:y];
        }
        
    }
    
    if (y > REFRESH_HEADER_HEIGHT) {
        [self animatedCircle];
    }
}

-(void)animatedCircle{
    if (self.isAnimating)
        return;
    

    [self.underCircle addSubview:self.faceImageView];
    self.isAnimating = TRUE;
    
    if (self.downloadedImage) {
        self.underCircle.backgroundColor = [UIColor colorWithPatternImage:self.downloadedImage];
    }
    
    //[self.pinkCircle.backgroundColor isEqual:[UIColor clearColor]] ? [UIColor purpleColor] : nil;
    self.pinkCircle.backgroundColor = [UIColor purpleColor];

    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.pinkCircle.layer.position = CGPointMake(CIRCLECENTERX, CIRCLECENTERY);
        self.pinkCircle.layer.position = CGPointMake(LEFTLIMIT, CIRCLECENTERY);
        
        
        self.underCircle.layer.position = CGPointMake(CIRCLECENTERX, CIRCLECENTERY);
        self.underCircle.layer.position = CGPointMake(RIGHTLIMIT, CIRCLECENTERY);
        
        
        CGAffineTransform transform = self.pinkCircle.transform;
        transform = CGAffineTransformScale(transform, MINORSCALE, MINORSCALE);
        self.pinkCircle.transform = transform;
        self.underCircle.transform = transform;
    }completion:^(BOOL finished){
        [self movePinkCircleRight];
    }];
    
    
    
}

-(void)movePinkCircleLeft{
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.pinkCircle.layer.position = CGPointMake(CIRCLECENTERX, CIRCLECENTERY);
        self.underCircle.layer.position = CGPointMake(CIRCLECENTERX, CIRCLECENTERY);
        
    } completion:^(BOOL finished){
        self.pinkCircle.backgroundColor = (!self.isDownloadFinished ?
                                           [UIColor purpleColor] :
                                           [UIColor colorWithPatternImage:self.downloadedImage]);
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.pinkCircle.layer.position = CGPointMake(LEFTLIMIT, CIRCLECENTERY);
            self.underCircle.layer.position = CGPointMake(RIGHTLIMIT, CIRCLECENTERY);
            
        } completion:^(BOOL finished){
            self.underCircle.layer.zPosition = -1;
            self.pinkCircle.layer.zPosition = 0;
            
            if (self.isDownloadFinished) {
                [self.underCircle.layer removeAllAnimations];
                [self.pinkCircle.layer removeAllAnimations];
                
                self.isLoading = NO;
                self.isAnimating = NO;

                
                [UIView animateWithDuration:1.0f animations:^{
                    CGAffineTransform pinkTransform = self.pinkCircle.transform;
                    CGAffineTransform underTransform = self.underCircle.transform;
                    
                    self.pinkCircle.layer.position = CGPointMake(CIRCLECENTERX, CIRCLECENTERY);
                    self.underCircle.layer.position = CGPointMake(CIRCLECENTERX, CIRCLECENTERY);
                    
                    pinkTransform = CGAffineTransformScale(pinkTransform, MAJORSCALE , MAJORSCALE);
                    self.pinkCircle.transform = pinkTransform;
                    
                    underTransform = CGAffineTransformScale(underTransform, MAJORSCALE , MAJORSCALE);
                    self.underCircle.transform = underTransform;
                    
                    self.shouldAnimate = NO;
                    [UIView animateWithDuration:1 animations:^{
                        self.myScrolView.contentInset = UIEdgeInsetsZero;
                    } completion:^(BOOL finished){
                        self.shouldAnimate = YES;
                        //self.underCircle.backgroundColor = [UIColor colorWithPatternImage:self.downloadedImage];
                        self.underCircle.backgroundColor = [UIColor clearColor];
                    }];
                    
                } ];
                
                
            } else {
                [self movePinkCircleRight];
            }
            
            
        }];
        
    }];
}

-(void)movePinkCircleRight{
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.underCircle.layer.position = CGPointMake(CIRCLECENTERX, CIRCLECENTERY);
        self.pinkCircle.layer.position = CGPointMake(CIRCLECENTERX, CIRCLECENTERY);
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.underCircle.layer.position = CGPointMake(LEFTLIMIT, CIRCLECENTERY);
            self.pinkCircle.layer.position = CGPointMake(RIGHTLIMIT, CIRCLECENTERY);
        } completion:^(BOOL finished){
            self.underCircle.layer.zPosition = 0;
            self.pinkCircle.layer.zPosition = -1;
            
            [self movePinkCircleLeft];
            //(!self.isDownloadFinished ? [self waitingRequestToFinish] : [self lastAnimation]);
        } ];
    }];
}

-(void)lastAnimation{
    [self movePinkCircleLeft];
}


-(void)waitingRequestToFinish{
    [self movePinkCircleLeft];
    //[self movePinkCircleRight];
}


-(void)drawUnderCircleForOffset:(CGFloat)offset{
    self.underCircle.backgroundColor = [UIColor blueColor];
    CAShapeLayer *shape = [CAShapeLayer layer];
    UIBezierPath *path;
    if (offset < REFRESH_HEADER_HEIGHT) {
        CGFloat endAngle = (2 * M_PI)*offset / REFRESH_HEADER_HEIGHT;
        
        path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(50, 50)];
        CGPoint next;
        next.x = 50 + 50 * cos(0);
        next.y = 50 + 50 * sin(0);
        [path addLineToPoint:next];
        [path addArcWithCenter:CGPointMake(50, 50) radius:50 startAngle:0 endAngle:endAngle clockwise:YES];
        [path addLineToPoint:CGPointMake(50, 50)];
        [path fill];
        
        NSLog(@"path = %@", path);
        
    } else {
        path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50)
                                              radius:50
                                          startAngle:0
                                            endAngle:(2 * M_PI)
                                           clockwise:YES];
    }
    shape.path = path.CGPath;
    self.underCircle.layer.mask = shape;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.isLoading)
        return;
    self.isDragging = true;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.isLoading)
        return;
    
    self.isDragging = NO;
    
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        [self startLoading];
    }
}

-(void)startLoading{
    self.isLoading = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self downloadImage];
        self.myScrolView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        //self.underCircle.layer.position = CGPointMake(250, 100);
    } completion:^(BOOL finished){
        
    }];
    
    //[self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

-(void)downloadImage{
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.uni-regensburg.de/Fakultaeten/phil_Fak_II/Psychologie/Psy_II/beautycheck/english/durchschnittsgesichter/m(01-32)_gr.jpg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.isDownloadFinished = NO;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        self.isDownloadFinished = YES;
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:data];
                UIImageView *faceImage = [[UIImageView alloc] initWithImage:image];
                
                faceImage.frame = CGRectMake(120, 50, 80, 100);
                
                
                CAShapeLayer *shape = [CAShapeLayer layer];
                UIBezierPath *path;
                
                path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(40, 50)
                                                      radius:40
                                                  startAngle:0
                                                    endAngle:(2 * M_PI)
                                                   clockwise:YES];
                shape.path = path.CGPath;
                faceImage.layer.mask = shape;
                
                self.faceImageView = faceImage;
                
                UIGraphicsBeginImageContext(self.pinkCircle.frame.size);
                [image drawInRect:self.pinkCircle.bounds];
                image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                self.downloadedImage = image;
                
                //self.pinkCircle.backgroundColor = [UIColor colorWithPatternImage:image];
                //[self performSelector:@selector(stopLoading) withObject:nil afterDelay:4.5];
            });
        }
    }] resume];
}

-(void)stopLoading{
    self.isLoading = NO;
    
    NSLog(@"self.underCircle.layer.position = %@ ",NSStringFromCGPoint([self.underCircle.layer.presentationLayer position]));
    
    CGPoint underCirclePoint = [self.underCircle.layer.presentationLayer position];
    CGPoint pinkCirclePoint = [self.pinkCircle.layer.presentationLayer position];
    
    self.pinkCircle.layer.position = pinkCirclePoint;
    self.underCircle.layer.position = underCirclePoint;
    
    [UIView animateWithDuration:1.0f animations:^{
        CGAffineTransform pinkTransform = self.pinkCircle.transform;
        CGAffineTransform underTransform = self.underCircle.transform;
        
        self.pinkCircle.layer.position = CGPointMake(CIRCLECENTERX, CIRCLECENTERY);
        self.underCircle.layer.position = CGPointMake(CIRCLECENTERX, CIRCLECENTERY);
        
        pinkTransform = CGAffineTransformScale(pinkTransform, MAJORSCALE , MAJORSCALE);
        self.pinkCircle.transform = pinkTransform;
        
        
        underTransform = CGAffineTransformScale(underTransform, MAJORSCALE , MAJORSCALE);
        self.underCircle.transform = underTransform;
        
    } completion:^(BOOL finished){
        [self.underCircle.layer removeAllAnimations];
        [self.pinkCircle.layer removeAllAnimations];
    }];
    
    
    self.shouldAnimate = NO;
    [UIView animateWithDuration:1 animations:^{
        self.myScrolView.contentInset = UIEdgeInsetsZero;
    } completion:^(BOOL finished){
        self.shouldAnimate = YES;
        self.underCircle.backgroundColor = [UIColor clearColor];
    }];
    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary     *)change context:(void *)context {
    
}



@end
