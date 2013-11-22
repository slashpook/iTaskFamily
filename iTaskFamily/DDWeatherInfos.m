//
//  DDWeatherInfos.m
//  ITaskFamily
//
//  Created by DAMIEN DELES on 02/05/12.
//  Copyright (c) 2012 INGESUP. All rights reserved.
//

#import "DDWeatherInfos.h"

@implementation DDWeatherInfos


#pragma mark - Weather fonctions

//On initialise la recherche
- (DDWeatherInfos *)initWithQuery:(NSString *)query andDelegate:(id<WeatherInfosProtocol>)delegate
{
    self = [super init];
    if (self) {
        [self setDelegate:delegate];
        [self setLocation:query];
        
        NSString *urlString = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v1/search.ashx?query=%@&num_of_results=1&format=json&key=zjt4n7rtpx9ehmy4m8byy7ew", query];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
        
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (self.connection)
        {
            _webData = [[NSMutableData alloc] init];
        }
        else
        {
            NSLog(@"theConnection is NULL");
        }
    }
    return self;
}

//RÉCUPÉRATION DES DONNÉES
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.webData appendData:data];
}

//FIN DE LA CONNEXION
- (void)connectionDidFinishLoading:(NSURLConnection *)conn{
    
    //Recupération du json
    NSDictionary *dictMeteo = [NSJSONSerialization JSONObjectWithData:self.webData options:NSJSONReadingMutableContainers error:nil];
    
    if ([[dictMeteo objectForKey:@"data"] objectForKey:@"error"] != nil)
    {
        [self.delegate searchEndedWithError:self];
    }
    else
    {
        NSDictionary *dictInfosCurrentMeteo = [[[dictMeteo objectForKey:@"data"] objectForKey:@"current_condition"] objectAtIndex:0];
        NSDictionary *dictInfosMeteo =  [[[dictMeteo objectForKey:@"data"] objectForKey:@"weather"] objectAtIndex:0];
        NSDictionary *dictInfoCity = [[[dictMeteo objectForKey:@"data"] objectForKey:@"request"] objectAtIndex:0];
        
        self.currentTemp = [[dictInfosCurrentMeteo objectForKey:@"temp_C"] intValue];
        self.lowTemp = [[dictInfosMeteo objectForKey:@"tempMinC"] intValue];
        self.hightTemp = [[dictInfosMeteo objectForKey:@"tempMaxC"] intValue];
        [self setCondition:[dictInfosMeteo objectForKey:@"weatherCode"]];
        [self setLocation:[[[dictInfoCity objectForKey:@"query"] componentsSeparatedByString:@","] objectAtIndex:0]];
        
        [self.delegate searchEnded:self];
    }
    
    //On supprime les données
    if (self.webData)
    {
        _webData = nil;
    }
    
    if (self.connection)
    {
        //On tue le lien de la connexion de toute façon elle est en autorelease
        _connection = nil;
    }

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //On supprime les données
    if (self.webData)
    {
        _webData = nil;
    }
    
    if (self.connection)
    {
        //On tue le lien de la connexion de toute façon elle est en autorelease
        _connection = nil;
    }
    
    [self.delegate searchEndedWithError:self];
}

@end
