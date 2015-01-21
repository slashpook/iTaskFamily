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
        
        //On initialise la variable pour se géolocaliser
        _locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    }
    return self;
}

//On met à jour la météo avec la requette passé en paramètre
- (void)updateMeteoWithQuery:(NSString *)query
{
    //On met à jour la ville
    [self setLocation:query];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v1/weather.ashx?key=zjt4n7rtpx9ehmy4m8byy7ew&q=%@&num_of_days=1&format=json", query] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        //Recupération du json
        NSDictionary *dictMeteo = responseObject;
        
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
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        [self resetData];
        [self.delegate searchEndedWithError:self];
    }];
}

//On se géolocalise pour afficher la météo
- (void)updateMeteoWithGeolocate
{
    [self.locationManager startUpdatingLocation];
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


#pragma mark CLLocationManager delegate functions

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //On arrète la recherche pour ne pas consommer trop d'énergie
    [self.locationManager stopUpdatingLocation];
    
    //On lance la meteo avec la ville par défault
    [self updateMeteoWithQuery:[[DDManagerSingleton instance] getMeteo]];
    
    [self.delegate searchEndedWithError:self];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //On arrète la recherche pour ne pas consommer trop d'énergie
    [self.locationManager stopUpdatingLocation];
    
    //On a une location
    if ([locations count] > 0) {
        //On géolocalisation
        [[DDManagerSingleton instance] setIsGeolocationActivate:YES];
        
        //On récupère la localisation
        [self newPhysicalLocation:[locations objectAtIndex:0]];
    }
    //On en a pas
    else {
        //On lance la meteo avec la ville par défault
        [self updateMeteoWithQuery:[[DDManagerSingleton instance] getMeteo]];
        
        [self.delegate searchEndedWithError:self];
    }
}

-(void)newPhysicalLocation:(CLLocation *)location
{
    _geoCoder = [[CLGeocoder alloc] init] ;
    
    [self.geoCoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         for (CLPlacemark *placemark in placemarks) {
             if (placemark.locality != nil) {
                 [self updateMeteoWithQuery:placemark.locality];
             }
             //Sinon on rempli les champs avec des informations d'erreur
             else
                 [[self delegate] searchEndedWithError:self];
         }
     }];
}

@end
