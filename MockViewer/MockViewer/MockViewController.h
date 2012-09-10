//
//  MockViewController.h
//  MockViewer
//
//  Created by Foy Savas on 7/31/12.
//  Copyright (c) 2012 Assembly Development Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MockViewController : UIViewController {
    NSString *imageUrl;
    UIImage *image;
}

@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGR;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeGR;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

-(id)initWithImageUrl:(NSString*)url;

@end
