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
- (DDWeatherInfos *)initWithDelegate:(id<DDWeatherInfosProtocol>)delegate
{
    self = [super init];
    if (self) {
        [self setDelegate:delegate];
        _webData = [[NSMutableData alloc] init];
    }
    return self;
}

//On met à jour la météo avec la requette passé en paramètre
- (void)updateMeteoWithQuery:(NSString *)query
{
    //On met à jour la ville
    [self setLocation:query];
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v1/weather.ashx?key=zjt4n7rtpx9ehmy4m8byy7ew&q=%@&num_of_days=1&format=json", query];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

//Récupération des données
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.webData appendData:data];
}

//Fin de la récupération de données
- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    //Recupération du json
    NSDictionary *dictMeteo = [NSJSONSerialization JSONObjectWithData:self.webData options:NSJSONReadingMutableContainers error:nil];
    
    //Si le dictionnaire est bon on récupère les données
    if ([[dictMeteo objectForKey:@"data"] objectForKey:@"error"] != nil)
    {
        //On réinitialise les données
        [self resetData];
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
        _webData.data = nil;
    
    if (self.connection)
        _connection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self resetData];
    
    //On supprime les données
    if (self.webData)
    {
        _webData.data = nil;
    }
    
    if (self.connection)
    {
        //On tue le lien de la connexion de toute façon elle est en autorelease
        _connection = nil;
    }
    
    [self.delegate searchEndedWithError:self];
}

//On réinitialise les données
- (void)resetData
{
    self.currentTemp = 0;
    self.lowTemp = 0;
    self.hightTemp = 0;
    [self setCondition:@""];
    [self setLocation:@"Météo"];
}

@end
