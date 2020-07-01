//
//  MoviesViewController.m
//  Flix
//
//  Created by chad franklin on 6/25/20.
//  Copyright © 2020 chad franklin. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieDetailsViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "CEFMovieFetcher.h"
#import "Movie.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *moviesTableView;
@property (nonatomic, strong) NSMutableArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.moviesTableView.dataSource = self;
    self.moviesTableView.delegate = self;
    
    [self getMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getMovies) forControlEvents:UIControlEventValueChanged];
    //[self.moviesTableView addSubview:self.refreshControl];
    [self.moviesTableView insertSubview:self.refreshControl atIndex:0];
}



//were named tableView by default
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 20;
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //UITableViewCell *cell = [[UITableViewCell alloc] init];
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    cell.movie = self.movies[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



- (void)getMovies{
    [self.activityIndicator startAnimating];
    //[CEFMovieFetcher.sharedObject getMovies:^(NSArray *movies) {
    [CEFMovieFetcher.sharedObject getMovies:^(BOOL success) {
        if(success){
            //self.movies = movies;
            NSLog(@"success");
            self.movies = CEFMovieFetcher.sharedObject.movies;
            [self.moviesTableView reloadData];
        } else {
            NSLog(@"fail");
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

// couldn't get non in-line block to work
/*
- (void)fetchMovies{
    [CEFMovieFetcher.sharedObject getMovies:movieFetchCallback];
    
}
void (^movieFetchCallback) (NSArray *movies) = ^(NSArray *movies){
    self.movies = movies;
    [self.refreshControl endRefreshing];
    [self.moviesTableView reloadData];
};
*/




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.moviesTableView indexPathForCell:tappedCell];
    Movie *movie = self.movies[indexPath.row];
    
    MovieDetailsViewController *movieDetailsViewController = [segue destinationViewController];
    movieDetailsViewController.movie = movie;
}




@end
