//
//  MoviesGridViewController.m
//  Flixster
//
//  Created by selinons on 6/26/19.
//  Copyright © 2019 codepath. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


@property (nonatomic, strong) NSArray *movies;


@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSArray *filteredData;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.searchBar.delegate = self;
    
    [self fetchMovies];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    CGFloat postersPerLine = 3;
    
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing*(postersPerLine-1))/postersPerLine;
    
    CGFloat itemHeight = 1.5 * itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}
- (void)fetchMovies{
    //Make the network call
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Fetch Movies" message:@"The Internet connection appears to be offline. Reconnect and try again!" preferredStyle:(UIAlertControllerStyleAlert)];
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
            
            //give the key to the dictionary to get the value of movies
            self.movies = dataDictionary[@"results"];
            [self.collectionView reloadData];
            self.data = self.movies;
            self.filteredData = self.data;
        }
    }];
    [task resume];
}


- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.item];
    NSString *smallerURLString = @"https://image.tmdb.org/t/p/w200";
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    if ([movie[@"poster_path"] isKindOfClass:[NSString class]]) {
        
        NSString *posterURLString = movie[@"poster_path"];
        NSString *fullSmallPosterURLString = [smallerURLString stringByAppendingString:posterURLString];
        NSString *fullLargePosterURLString = [baseURLString stringByAppendingString:posterURLString];
        
        NSURL *smallPosterURL = [NSURL URLWithString:fullSmallPosterURLString];
        NSURL *largePosterURL = [NSURL URLWithString:fullLargePosterURLString];
            NSURLRequest *requestSmall = [NSURLRequest requestWithURL:smallPosterURL];
            NSURLRequest *requestLarge = [NSURLRequest requestWithURL:largePosterURL];
            
            __weak MovieCollectionCell *weakCell = cell;
            
            [cell.posterView setImageWithURLRequest:requestSmall
                                  placeholderImage:nil
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
                                               
                                               // smallImageResponse will be nil if the smallImage is already available
                                               // in cache (might want to do something smarter in that case).
                                               weakCell.posterView.alpha = 0.0;
                                               weakCell.posterView.image = smallImage;
                                               
                                               [UIView animateWithDuration:0.3
                                                                animations:^{
                                                                    
                                                                    weakCell.posterView.alpha = 1.0;
                                                                    
                                                                } completion:^(BOOL finished) {
                                                                    // The AFNetworking ImageView Category only allows one request to be sent at a time
                                                                    // per ImageView. This code must be in the completion block.
                                                                    [weakCell.posterView setImageWithURLRequest:requestLarge
                                                                                              placeholderImage:smallImage
                                                                                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                                                                                           weakCell.posterView.image = largeImage;
                                                                                                       }
                                                                                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                           // do something for the failure condition of the large image request
                                                                                                           //weakCell.posterView.image = defaultImage;
                                                                                                           NSLog(@"doing stuff later");
                                                                                                       }];
                                                                }];
                                           }
                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                               // do something for the failure condition
                                               // possibly try to get the large image
                                           }];
    }
    else{
        cell.posterView.image = nil;
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        self.filteredData = [self.data filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredData = self.data;
    }
    
    [self.collectionView reloadData];
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self fetchMovies];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
    NSLog(@"Tapping on a movie!");
}

@end
