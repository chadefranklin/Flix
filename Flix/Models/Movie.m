//
//  Movie.m
//  Flix
//
//  Created by chadfranklin on 7/1/20.
//  Copyright © 2020 chad franklin. All rights reserved.
//

#import "Movie.h"

@implementation Movie

const NSString *BASE_IMAGE_URL_Large = @"https://image.tmdb.org/t/p/w500";
const NSString *BASE_IMAGE_URL_Small = @"https://image.tmdb.org/t/p/w200";

+ (NSMutableArray *)moviesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *movies = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];

        [movies addObject:movie];
    }
    return movies;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];

    self.title = dictionary[@"title"];
    self.overview = dictionary[@"overview"];

    if ([dictionary[@"poster_path"] isKindOfClass:[NSString class]]){
        self.posterUrl = [NSURL URLWithString:[BASE_IMAGE_URL_Small stringByAppendingString:dictionary[@"poster_path"]]];
    }else {
        self.posterUrl = nil;
    }
    if ([dictionary[@"backdrop_path"] isKindOfClass:[NSString class]]){
        self.smallBackdropUrl = [NSURL URLWithString:[BASE_IMAGE_URL_Small stringByAppendingString:dictionary[@"backdrop_path"]]];
        self.largeBackdropUrl = [NSURL URLWithString:[BASE_IMAGE_URL_Large stringByAppendingString:dictionary[@"backdrop_path"]]];
    } else {
        self.smallBackdropUrl = nil;
        self.largeBackdropUrl = nil;
    }

return self;
}

@end
