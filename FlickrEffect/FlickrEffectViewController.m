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
    //self.underCircle = [[UIView alloc] init];
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
        
        //NSLog(@"y = %f", y);
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
    self.pinkCircle.backgroundColor = [UIColor purpleColor];
    
    /*CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSValue valueWithCGPoint:CGPointMake(160, 100)];
    rotation.toValue = [NSValue valueWithCGPoint:CGPointMake(260, 100)];
    rotation.duration = 1.1; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [self.underCircle.layer addAnimation:rotation forKey:@"Spin"];*/
    
    self.pinkCircle.layer.zPosition = -1;
    
    [UIView animateWithDuration:1.0f animations:^{
        
        self.pinkCircle.layer.position = CGPointMake(CIRCLECENTERX, CIRCLECENTERY);
        self.pinkCircle.layer.position = CGPointMake(LEFTLIMIT, CIRCLECENTERY);
        
        
        self.underCircle.layer.position = CGPointMake(CIRCLECENTERX, CIRCLECENTERY);
        self.underCircle.layer.position = CGPointMake(RIGHTLIMIT, CIRCLECENTERY);
        
        
        CGAffineTransform transform = self.pinkCircle.transform;
        transform = CGAffineTransformScale(transform, MINORSCALE, MINORSCALE);
        self.pinkCircle.transform = transform;
        self.underCircle.transform = transform;
    }completion:^(BOOL finished){
        [UIView animateWithDuration:1.0f  delay:0 options:( UIViewAnimationOptionRepeat |UIViewAnimationOptionAutoreverse ) animations:^{
            self.pinkCircle.layer.position = CGPointMake(LEFTLIMIT, CIRCLECENTERY);
            self.pinkCircle.layer.position = CGPointMake(RIGHTLIMIT, CIRCLECENTERY);
            self.underCircle.layer.zPosition = -2;
            self.pinkCircle.layer.zPosition = 2;
            
            self.underCircle.layer.position = CGPointMake(RIGHTLIMIT, CIRCLECENTERY);
            self.underCircle.layer.position = CGPointMake(LEFTLIMIT, CIRCLECENTERY);
            self.underCircle.layer.zPosition = 2;
            self.pinkCircle.layer.zPosition = -2;
            
            
        } completion:^(BOOL finished){
            self.isAnimating = FALSE;
            self.underCircle.layer.zPosition = -999;
            /*NSTimeInterval duration = 1 - abs(self.pinkCircle.layer.frame.origin.x/160);
            
            [UIView animateWithDuration:duration animations:^{
                self.underCircle.layer.position = CGPointMake(160, 100);
                self.pinkCircle.layer.position = CGPointMake(160, 100);
            }];*/
            
            //self.underCircle.layer.position = CGPointMake(160, 100);
        }];
    }];
    
    
    
    
}

-(void)drawUnderCircleForOffset:(CGFloat)offset{
    self.underCircle.backgroundColor = [UIColor blueColor];
    CAShapeLayer *shape = [CAShapeLayer layer];
    UIBezierPath *path;
    if (offset < REFRESH_HEADER_HEIGHT) {
        CGFloat endAngle = (2 * M_PI)*offset / REFRESH_HEADER_HEIGHT;
        //NSLog(@"endAngle = %f", endAngle);
        
        path = [UIBezierPath bezierPath]; //empty path
        [path moveToPoint:CGPointMake(50, 50)];
        CGPoint next;
        next.x = 50 + 50 * cos(0);
        next.y = 50 + 50 * sin(0);
        [path addLineToPoint:next]; //go one end of arc
        [path addArcWithCenter:CGPointMake(50, 50) radius:50 startAngle:0 endAngle:endAngle clockwise:YES]; //add the arc
        [path addLineToPoint:CGPointMake(50, 50)];
        [path fill];
        
        /*path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50)
                                              radius:50
                                          startAngle:0
                                            endAngle:endAngle
                                           clockwise:YES];*/
        NSLog(@"path = %@", path);
        
    //}if (offset == REFRESH_HEADER_HEIGHT) {
        
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
        //already loading, don't do anything
        return;
    
    //not dragging anymore
    self.isDragging = NO;
    
    //if scroll area is bigger than some constant defined before, do the action
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    } /*else if (scrollView.contentOffset.y <= REFRESH_HEADER_HEIGHT) {
       self.actionButton.backgroundColor = [UIColor clearColor];
       }*/
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
    NSURL *url = [NSURL URLWithString:@"http://m.abril.com/face.jpeg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
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
                
                self.pinkCircle.backgroundColor = [UIColor colorWithPatternImage:image];
                [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.5];
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
        //self.myScrolView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        self.myScrolView.contentInset = UIEdgeInsetsZero;
    } completion:^(BOOL finished){
        self.shouldAnimate = YES;
        //self.pinkCircle.backgroundColor = [UIColor clearColor];
        self.underCircle.backgroundColor = [UIColor clearColor];
        //self.myScrolView.contentInset = UIEdgeInsetsZero;
    }];
    
    
}


@end
