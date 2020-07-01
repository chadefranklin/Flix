//
//  MovieCell.m
//  Flix
//
//  Created by chad franklin on 6/25/20.
//  Copyright © 2020 chad franklin. All rights reserved.
//

#import "MovieCell.h"
#import "CEFMovieFetcher.h"
#import "UIImageView+AFNetworking.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMovie:(Movie *)movie {
    // Since we're replacing the default setter, we have to set the underlying private storage _movie ourselves.
    // _movie was an automatically declared variable with the @propery declaration.
    // You need to do this any time you create a custom setter.
    _movie = movie;
    
    self.titleLabel.text = movie.title;
    self.synopsisLabel.text = movie.overview;
    
    //cell.posterView.image = nil;
    //if ([movie[@"poster_path"] isKindOfClass:[NSString class]]){
    if (movie.posterUrl){
        NSURLRequest *request = [NSURLRequest requestWithURL:movie.posterUrl];

        __weak MovieCell *weakCell = self; // is this correct usage?
        [self.posterView setImageWithURLRequest:request placeholderImage:nil
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
        self.posterView.image = nil;
    }
}

@end
