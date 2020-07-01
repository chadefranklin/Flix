//
//  Movie.h
//  Flix
//
//  Created by chadfranklin on 7/1/20.
//  Copyright © 2020 chad franklin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong, nullable) NSURL *posterUrl;
@property (nonatomic, strong, nullable) NSURL *smallBackdropUrl;
@property (nonatomic, strong, nullable) NSURL *largeBackdropUrl;

+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
