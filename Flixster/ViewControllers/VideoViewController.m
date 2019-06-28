//
//  VideoViewController.m
//  Flixster
//
//  Created by selinons on 6/27/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "VideoViewController.h"
#import <WebKit/WebKit.h>

@interface VideoViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (nonatomic, strong) NSString *video;
@property (nonatomic, strong) NSString *videoKey;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *someUrlString = [@"https://api.themoviedb.org/3/movie/" stringByAppendingString:self.videoID];
    NSString *allUrlString = [someUrlString stringByAppendingString:@"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    //Make the network call
    NSURL *url = [NSURL URLWithString:allUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Fetch Video" message:@"The Internet connection appears to be offline. Reconnect and try again!" preferredStyle:(UIAlertControllerStyleAlert)];
            // create a cancel action
            
            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Dismiss"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
                                                             }];
            // add the OK action to the alert controller
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@", dataDictionary);
            
            NSArray *allTrailers = dataDictionary[@"results"];
            NSLog(@"%@", allTrailers[0]);
            NSDictionary *firstTrailer = allTrailers[0];
            
            self.videoKey = [NSString stringWithFormat:@"%@", firstTrailer[@"key"]];
            // Convert the url String to a NSURL object.
            NSLog(@"%@", self.videoKey);
            
            
            NSString *baseURLString = @"https://www.youtube.com/watch?v=";
            if (self.videoKey!=nil)
            {
                NSString *videoURLString = self.videoKey;
                NSLog(@"%@", self.videoKey);
                NSString *fullVideoURLString = [baseURLString stringByAppendingString:videoURLString];
                ;
                NSLog(@"%@", fullVideoURLString);
                NSURL *url = [NSURL URLWithString:fullVideoURLString];
                
                // Place the URL in a URL Request.
                NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                         cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                     timeoutInterval:10.0];
                // Load Request into WebView.
                [self.webView loadRequest:request];
            }
            
        }
    }];
    [task resume];
    
    
}/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
