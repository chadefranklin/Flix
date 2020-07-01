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
    
    
    if (self.movie.posterUrl){
        NSURLRequest *request = [NSURLRequest requestWithURL:self.movie.posterUrl];

        __weak MovieDetailsViewController *weakSelf = self;
        [self.posterView setImageWithURLRequest:request placeholderImage:nil
                                        success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                            
                                            // imageResponse will be nil if the image is cached
                                            if (imageResponse) {
                                                NSLog(@"Image was NOT cached, fade in image");
                                                weakSelf.posterView.alpha = 0.0;
                                                weakSelf.posterView.image = image;
                                                
                                                //Animate UIImageView back to alpha 1 over 0.3sec
                                                [UIView animateWithDuration:0.3 animations:^{
                                                    weakSelf.posterView.alpha = 1.0;
                                                }];
                                            }
                                            else {
                                                NSLog(@"Image was cached so just update the image");
                                                weakSelf.posterView.image = image;
                                            }
                                        }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                            // do something for the failure condition
                                            weakSelf.posterView.image = nil; // ???
                                        }];
    } else {
        self.posterView.image = nil;
    }
    
    
    
    // the mafia didn't have a backdrop. caused an error before using this.
    // look more into network "error handling"
    if (self.movie.smallBackdropUrl){
        NSURLRequest *requestSmall = [NSURLRequest requestWithURL:self.movie.smallBackdropUrl];
        NSURLRequest *requestLarge = [NSURLRequest requestWithURL:self.movie.largeBackdropUrl];
        
        __weak MovieDetailsViewController *weakSelf = self;
        [self.backdropView setImageWithURLRequest:requestSmall
        placeholderImage:nil
                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
                     
                     // smallImageResponse will be nil if the smallImage is already available
                     // in cache (might want to do something smarter in that case).
                     weakSelf.backdropView.alpha = 0.0;
                     weakSelf.backdropView.image = smallImage;
                     
                     [UIView animateWithDuration:0.3
                                      animations:^{
                                          
                                          weakSelf.backdropView.alpha = 1.0;
                                          
                                      } completion:^(BOOL finished) {
                                          // The AFNetworking ImageView Category only allows one request to be sent at a time
                                          // per ImageView. This code must be in the completion block.
                                          [weakSelf.backdropView setImageWithURLRequest:requestLarge
                                                                placeholderImage:smallImage
                                                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                                                              weakSelf.backdropView.image = largeImage;
                                                                }
                                                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                             // do something for the failure condition of the large image request
                                                                             // possibly setting the ImageView's image to a default image
                                                                            // do nothing? might be able to keep small image
                                                                         }];
                                      }];
                 }
                 failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                     // do something for the failure condition
                     // possibly try to get the large image
                     weakSelf.backdropView.image = nil; // ???
                 }];
        
    } else {
        self.backdropView.image = nil;
    }

    
    
    
    self.titleLabel.text = self.movie.title;
    self.synopsisLabel.text = self.movie.overview;
    
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
