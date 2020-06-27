//
//  MovieDetailsViewController.m
//  Flix
//
//  Created by chad franklin on 6/25/20.
//  Copyright © 2020 chad franklin. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CEFMovieFetcher.h"

@interface MovieDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if ([self.movie[@"poster_path"] isKindOfClass:[NSString class]]){
        NSString *posterURLString = self.movie[@"poster_path"];
        [self.posterView setImageWithURL:[CEFMovieFetcher.sharedObject makePosterURL:posterURLString]];
    } else {
        self.posterView.image = nil;
    }
    
    
    
    // the mafia didn't have a backdrop. caused an error before using this.
    // look more into network "error handling"
    if ([self.movie[@"backdrop_path"] isKindOfClass:[NSString class]]){
        NSString *backdropURLString = self.movie[@"backdrop_path"];
        [self.backdropView setImageWithURL:[CEFMovieFetcher.sharedObject makeBackdropURL:backdropURLString]];
    } else {
        self.backdropView.image = nil;
    }

    
    
    
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    
    // dont do in auto layout
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
