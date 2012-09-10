//
//  MockViewController.m
//  MockViewer
//
//  Created by Foy Savas on 7/31/12.
//  Copyright (c) 2012 Assembly Development Corp. All rights reserved.
//

#import "MockViewController.h"
#import "Base64.h"
#import "Config.h"

@interface MockViewController ()

@end

@implementation MockViewController

@synthesize imageView, longPressGR, swipeGR, scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithImageUrl:(NSString*)url;
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        imageUrl = url;
    }
    return self;
}

-(void) handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated 
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageUrl]
                                                           cachePolicy: NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:3];
    if (USE_HTTP_AUTH) {
        NSMutableString *loginString = (NSMutableString*)[@"" stringByAppendingFormat:@"%@:%@", HOST_USER, HOST_PASS];
        NSString *encodedLoginData = [Base64 encode:[loginString dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *authHeader = [@"Basic " stringByAppendingFormat:@"%@", encodedLoginData];
        [request addValue:authHeader forHTTPHeaderField:@"Authorization"];
    }
    NSHTTPURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    image = [[UIImage alloc] initWithData:responseData];
    self.imageView.image = image;
    // 320,640
    if (self.imageView.image.size.width == 320) {
        CGRect newFrame =  self.imageView.frame;
        newFrame.size.width = 320;
        newFrame.size.height = self.imageView.image.size.height;
        self.imageView.frame = newFrame;
        self.scrollView.contentSize = newFrame.size;
        [self.scrollView setAlwaysBounceVertical:YES];
    } else if (self.imageView.image.size.width == 640) {
        CGRect newFrame =  self.imageView.frame;
        newFrame.size.width = 320;
        newFrame.size.height = self.imageView.image.size.height / 2;
        self.imageView.frame = newFrame;
        self.scrollView.contentSize = newFrame.size;
        [self.scrollView setAlwaysBounceVertical:YES];
    } else if (self.imageView.image.size.width == 480) {
        [self.scrollView setAlwaysBounceHorizontal:YES];
        CGRect newFrame =  self.imageView.frame;
        CGRect rotFrame = self.imageView.frame;
        rotFrame.size.height = newFrame.size.width = 480;
        rotFrame.size.width = newFrame.size.height = self.imageView.image.size.height;
        self.imageView.frame = newFrame;
        self.scrollView.contentSize = rotFrame.size;
        imageView.layer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(M_PI_2));
        CGRect corFrame = imageView.frame;
        corFrame.origin.y = corFrame.origin.x = 0;
        imageView.frame = corFrame;
        [self.scrollView setContentOffset:CGPointMake(image.size.height,0) animated:NO];
    } else if (self.imageView.image.size.width == 960) {
        [self.scrollView setAlwaysBounceHorizontal:YES];
        [self.scrollView setScrollEnabled:YES];
        CGRect newFrame =  self.imageView.frame;
        CGRect rotFrame = self.imageView.frame;
        rotFrame.size.height = newFrame.size.width = 480;
        rotFrame.size.width = newFrame.size.height = self.imageView.image.size.height / 2;
        self.imageView.frame = newFrame;
        self.scrollView.contentSize = rotFrame.size;
        imageView.layer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(M_PI_2));
        CGRect corFrame = imageView.frame;
        corFrame.origin.y = corFrame.origin.x = 0;
        imageView.frame = corFrame;
        [self.scrollView setContentOffset:CGPointMake(image.size.height,0) animated:NO];
    }
    CGRect corFrame = imageView.frame;
    corFrame.origin.y = corFrame.origin.x = 0;
    imageView.frame = corFrame;
    NSLog(@"%f,%f %f,%f", self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
    // 480,960
    // Do any additional setup after loading the view from its nib.
    
//    recognizer = [[ UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
//    swipeUpGR = (UISwipeGestureRecognizer *)recognizer;
//    swipeUpGR.numberOfTouchesRequired = 1;
//    swipeUpGR.direction = UISwipeGestureRecognizerDirectionUp;  //change Up to Right, Left or down
//    [self.view addGestureRecognizer:swipeUpGR];
    
    longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGR.minimumPressDuration = 0.5;
    [self.view addGestureRecognizer:longPressGR];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
