//
//  HNKMapViewController.h
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Tom OMalley on 8/11/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class HNKMapViewController;

@protocol HNKMapViewControllerDelegate <NSObject>

- (void)doneUpdateLocation:(HNKMapViewController *)viewController CurLoc:(NSString *)mLoc CurAddr:(NSString *)mAddr;

@end

@interface HNKMapViewController : UIViewController
@property (nonatomic, strong) id <HNKMapViewControllerDelegate> delegate;
@property (nonatomic, assign) CLLocationCoordinate2D m_CurCoordinate;
@property (nonatomic) NSString *mLocation;
@property (nonatomic) NSString *mAddress;

- (IBAction)onBackClick:(id)sender;
- (IBAction)onUpdateAddr:(id)sender;

@end
