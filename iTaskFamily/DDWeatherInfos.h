//
//  DDWeatherInfos.h
//  ITaskFamily
//
//  Created by DAMIEN DELES on 02/05/12.
//  Copyright (c) 2012 INGESUP. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeatherInfosProtocol <NSObject>

-(void)searchEnded:(id)weatherInfos;
-(void)searchEndedWithError:(id)weatherInfos;

@end

@interface DDWeatherInfos : NSObject <NSURLConnectionDelegate>


#pragma mark - Variables

@property(nonatomic, retain) NSString *condition;

@property(nonatomic, retain) NSString *location;

@property(nonatomic, retain) NSURL *conditionImageURL;

@property(nonatomic, assign) NSInteger currentTemp;

@property(nonatomic, assign) NSInteger lowTemp;

@property(nonatomic, assign) NSInteger hightTemp;

@property(nonatomic, retain) NSURLConnection *connection;

@property(nonatomic, retain) NSMutableData *webData;

@property(nonatomic, retain) id<WeatherInfosProtocol> delegate;


#pragma mark - Fonctions

- (DDWeatherInfos *)initWithQuery:(NSString *)query andDelegate:(id<WeatherInfosProtocol>)delegate;

@end
