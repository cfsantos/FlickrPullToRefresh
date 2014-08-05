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
    self.isAnimating = FALSE;
    self.myScrolView.delegate = self;
    self.myScrolView.contentSize = CGSizeMake(320, 4000);
    
    self.myImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"garden.jpg"]];
    self.myImageView.frame = CGRectMake(0, 0, 320, 200);
    [self.myScrolView addSubview:self.myImageView];
    
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
    
    self.underCircle.backgroundColor = [UIColor clearColor];
    [self.myImageView addSubview:self.underCircle];
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
        
        [self drawUnderCircleForOffset:y];
    }
    
    if (y > REFRESH_HEADER_HEIGHT) {
        [self animatedCircle];
    }
}

-(void)animatedCircle{
    if (self.isAnimating)
        return;
    
    self.isAnimating = TRUE;
    [UIView animateWithDuration:2 animations:^{
        self.underCircle.layer.position = CGPointMake(250, 100);
    } completion:^(BOOL finished){
        self.isAnimating = FALSE;
        self.underCircle.layer.position = CGPointMake(160, 100);
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
                
                
                /*UIView *view = [[UIView alloc] initWithFrame:CGRectMake(120, 350, 200, 200)];
                view.backgroundColor = [UIColor blueColor];*/
                
                CAShapeLayer *shape = [CAShapeLayer layer];
                UIBezierPath *path;
                
                path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(40, 50)
                                                      radius:40
                                                  startAngle:0
                                                    endAngle:(2 * M_PI)
                                                   clockwise:YES];
                shape.path = path.CGPath;
                faceImage.layer.mask = shape;
                

                
                /*CAShapeLayer *shape = [CAShapeLayer layer];
                UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:faceImage.center radius:(2*faceImage.bounds.size.width) startAngle:0 endAngle:(2 * M_PI) clockwise:YES];
                shape.path = path.CGPath;
                faceImage.layer.mask=shape;*/
                
                [self.myImageView addSubview:faceImage];
                [self performSelector:@selector(stopLoading) withObject:nil afterDelay:3.0];
                //[self stopLoading];
            });
        }
    }] resume];
}

-(void)stopLoading{
    self.isLoading = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.myScrolView.contentInset = UIEdgeInsetsZero;
    }];
}


@end
