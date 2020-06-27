//
//  CEFMovieFetcher.h
//  Flix
//
//  Created by chadfranklin on 6/26/20.
//  Copyright © 2020 chad franklin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CEFMovieFetcher : NSObject

+ (CEFMovieFetcher *)sharedObject;

- (void) getMovies:(void (^)(NSArray * _Nonnull movies))completionHandler;


@property (nonatomic, strong) NSArray *movies;

@end

NS_ASSUME_NONNULL_END
