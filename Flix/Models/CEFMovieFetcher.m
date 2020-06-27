//
//  CEFMovieFetcher.m
//  Flix
//
//  Created by chadfranklin on 6/26/20.
//  Copyright © 2020 chad franklin. All rights reserved.
//

#import "CEFMovieFetcher.h"

@implementation CEFMovieFetcher

const NSString *BASE_IMAGE_URL_Large = @"https://image.tmdb.org/t/p/w500";
const NSString *BASE_IMAGE_URL_Small = @"https://image.tmdb.org/t/p/w200";


+ (CEFMovieFetcher *)sharedObject {
    static CEFMovieFetcher *sharedClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClass = [[self alloc] init];
    });
    return sharedClass;
}






//- (void) fetchMovies { NSLog(@"Fetching");}


//- (void) getMovies:(void (^)(NSArray * _Nonnull movies))completionHandler{
- (void) getMovies:(void (^)(BOOL success))completionHandler{
    
    if(self.movies.count == 0) // haven't requested yet (or haven't received response yet. may need to check if i've requested already, but this works for now)
    {
        NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
               if (error != nil) {
                   NSLog(@"%@", [error localizedDescription]);
                   completionHandler(NO);
               }
               else {
                   NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                   
                   //NSLog(@"%@", dataDictionary);
                   
                   self.movies = dataDictionary[@"results"];
                   
                   NSLog(@"movies fetched successfully");
                   completionHandler(YES);
               }
            //completionHandler(self.movies); // this should happen whether it errors or not.
            
           }];
        [task resume];
    } else
    {
        //completionHandler(self.movies);
        completionHandler(YES);
    }
}

//- (NSURL *) makeImageURL:(NSString *) partialImageURLString{
- (NSURLRequest *) makeImageURLRequest:(NSString *) partialImageURLString{
    NSString *fullImageURLString = [BASE_IMAGE_URL_Large stringByAppendingFormat:partialImageURLString];
    NSURL *imageURL = [NSURL URLWithString:fullImageURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    return request;
}

- (NSURLRequest *) makeSmallImageURLRequest:(NSString *) partialImageURLString{
    NSString *fullImageURLString = [BASE_IMAGE_URL_Small stringByAppendingFormat:partialImageURLString];
    NSURL *imageURL = [NSURL URLWithString:fullImageURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    return request;
}



@end
