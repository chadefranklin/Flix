//
//  MoviesGridViewController.m
//  Flix
//
//  Created by chadfranklin on 6/26/20.
//  Copyright © 2020 chad franklin. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieDetailsViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "CEFMovieFetcher.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *moviesCollectionView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end

@implementation MoviesGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.moviesCollectionView.dataSource = self;
    self.moviesCollectionView.delegate = self;
    
    [self getMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getMovies) forControlEvents:UIControlEventValueChanged];
    //[self.moviesTableView addSubview:self.refreshControl];
    [self.moviesCollectionView insertSubview:self.refreshControl atIndex:0];
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.moviesCollectionView.collectionViewLayout;
    
    int rowSpace = layout.minimumInteritemSpacing = 5;
    int lineSpace = layout.minimumLineSpacing = 5;
    
    CGFloat postersPerRow = 3;
    CGFloat posterWidth = (self.moviesCollectionView.frame.size.width - rowSpace * (postersPerRow - 1)) / postersPerRow;
    CGFloat posterHeight = posterWidth * 1.6;
    
    layout.itemSize = CGSizeMake(posterWidth, posterHeight);
}













- (void)getMovies{
    [self.activityIndicator startAnimating];
    //[CEFMovieFetcher.sharedObject getMovies:^(NSArray *movies) {
    [CEFMovieFetcher.sharedObject getMovies:^(BOOL success) {
        if(success){
            //self.movies = movies;
            self.movies = CEFMovieFetcher.sharedObject.movies;
            [self.moviesCollectionView reloadData];
        } else {
            // show error
            [self displayFetchMovieAlert];
        }
        
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
    }];
    
}

- (void)displayFetchMovieAlert{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Failed To Connect"
           message:@"The Internet Connection Appears To Be Offline."
    preferredStyle:(UIAlertControllerStyleAlert)];
    
    /*
    // create a cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle cancel response here. Doing nothing will dismiss the view.
                                                      }];
    // add the cancel action to the alertController
    [alert addAction:cancelAction];
     */
    
    // create an OK action
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                        [self getMovies];
                                                     }];
    // add the OK action to the alert controller
    [alert addAction:tryAgainAction];
    
    
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
        NSLog(@"alert controller finished presenting");
    }];
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.moviesCollectionView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.item];
    
    MovieDetailsViewController *movieDetailsViewController = [segue destinationViewController];
    movieDetailsViewController.movie = movie;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    
    
    
    NSDictionary *movie = self.movies[indexPath.item];
    
    //cell.titleLabel.text = movie[@"title"];
    //cell.synopsisLabel.text = movie[@"overview"];
    
    cell.posterView.image = nil;
    if ([movie[@"poster_path"] isKindOfClass:[NSString class]]){
        NSString *posterURLString = movie[@"poster_path"];
        //[cell.posterView setImageWithURL:[CEFMovieFetcher.sharedObject makeBackdropURL:posterURLString]];
        
        
        
        
        NSURLRequest *request = [CEFMovieFetcher.sharedObject makeSmallImageURLRequest:posterURLString];

        __weak MovieCollectionCell *weakCell = cell;
        [cell.posterView setImageWithURLRequest:request placeholderImage:nil
                                        success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                            
                                            // imageResponse will be nil if the image is cached
                                            if (imageResponse) {
                                                NSLog(@"Image was NOT cached, fade in image");
                                                weakCell.posterView.alpha = 0.0;
                                                weakCell.posterView.image = image;
                                                
                                                //Animate UIImageView back to alpha 1 over 0.3sec
                                                [UIView animateWithDuration:0.3 animations:^{
                                                    weakCell.posterView.alpha = 1.0;
                                                }];
                                            }
                                            else {
                                                NSLog(@"Image was cached so just update the image");
                                                weakCell.posterView.image = image;
                                            }
                                        }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                            // do something for the failure condition
                                            weakCell.posterView.image = nil;
                                        }];
    } else {
        cell.posterView.image = nil;
    }
    
    
    
    
    
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

@end
