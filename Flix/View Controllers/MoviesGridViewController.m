//
//  MoviesGridViewController.m
//  Flix
//
//  Created by chadfranklin on 6/26/20.
//  Copyright © 2020 chad franklin. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "CEFMovieFetcher.h"

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *moviesCollectionView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

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
    [CEFMovieFetcher.sharedObject getMovies:^(NSArray *movies) {
        self.movies = movies;
        [self.refreshControl endRefreshing];
        [self.moviesCollectionView reloadData];
    }];
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    
    
    
    NSDictionary *movie = self.movies[indexPath.item];
    
    //cell.titleLabel.text = movie[@"title"];
    //cell.synopsisLabel.text = movie[@"overview"];
    
    cell.posterView.image = nil;
    if ([movie[@"poster_path"] isKindOfClass:[NSString class]]){
        NSString *posterURLString = movie[@"poster_path"];
        [cell.posterView setImageWithURL:[CEFMovieFetcher.sharedObject makeBackdropURL:posterURLString]];
    } else {
        cell.posterView.image = nil;
    }
    
    
    
    
    
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

@end
