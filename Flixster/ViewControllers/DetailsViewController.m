//
//  DetailsViewController.m
//  Flixster
//
//  Created by selinons on 6/26/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "VideoViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    if ([self.movie[@"poster_path"] isKindOfClass:[NSString class]]) {
        NSString *posterURLString = self.movie[@"poster_path"];
        NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
        
        NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
        if (self.posterView.image==nil)
        {
            self.posterView.alpha = 0;
            [self.posterView setImageWithURL:posterURL];
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.3 animations:^{
                self.posterView.alpha = 1.0;
            }];
        }
        else {
            [self.posterView setImageWithURL:posterURL];
        }
    }
    else{self.posterView.image = nil;}
    if ([self.movie[@"poster_path"] isKindOfClass:[NSString class]]) {
        NSString *backdropURLString = self.movie[@"backdrop_path"];
        NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
        
        NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
        if (self.backdropView.image==nil)
        {
            self.backdropView.alpha = 0;
            [self.backdropView setImageWithURL:backdropURL];

            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.3 animations:^{
                self.backdropView.alpha = 1.0;
            }];
        }
        else {
            [self.backdropView setImageWithURL:backdropURL];
        }
    }
    else{self.posterView.image = nil;}
    
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
}

- (IBAction)onTap:(id)sender {
    [self performSegueWithIdentifier:@"videoSegue" sender:nil];

}

#pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     NSString *movieID = [NSString stringWithFormat:@"%@", self.movie[@"id"]];
     VideoViewController *videoViewController = [segue destinationViewController];
     videoViewController.videoID = movieID;
     
 }
@end
