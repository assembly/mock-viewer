//
//  MocksViewController.m
//  MockViewer
//
//  Created by Foy Savas on 7/31/12.
//  Copyright (c) 2012 Assembly Development Corp. All rights reserved.
//

#import "Config.h"
#import "MocksViewController.h"
#import "MockViewController.h"
#import "Base64.h"
#import "Config.h"

@interface MocksViewController ()

@end

@implementation MocksViewController

@synthesize filenames;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.filenames = [[NSMutableArray alloc] init];
        // Custom initialization
        self.title = @"Mock Viewer";
    }
    return self;
}

- (void)refreshList:(id)sender
{
    self.filenames = [[NSMutableArray alloc] init];
    NSURL* url = [NSURL URLWithString:HOST_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
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
    NSString *responseBody = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",responseBody);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"href=\"[a-z0-9-_]+.png\"" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:responseBody options:0 range:NSMakeRange(0, [responseBody length])];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        [filenames addObject:[responseBody substringWithRange:NSMakeRange(matchRange.location+6, matchRange.length-6-1)]];
    }
    [[self tableView] reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshList:)];
    [self refreshList:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [filenames count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    } 
    NSString *cellValue = [filenames objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fn = [filenames objectAtIndex:indexPath.row];
    MockViewController *vc = [[MockViewController alloc] initWithImageUrl:[NSString stringWithFormat:@"http://mocks.loudly.com/%@", fn]];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
