//
//  ViewController.m
//  OpenHardware
//
//  Created by Kingyeung.Chan on 16/10/5.
//  Copyright © 2016年 Kingyeung.Chan. All rights reserved.
//

#import "ControlPanelViewController.h"

#import <AmazonAd/AmazonAdView.h>
#import <AmazonAd/AmazonAdOptions.h>
#import <AmazonAd/AmazonAdError.h>
@import GoogleMobileAds;

@interface ControlPanelViewController ()<AmazonAdViewDelegate>
@property (weak, nonatomic) IBOutlet GADBannerView *bennerView;

@property (weak, nonatomic) IBOutlet AmazonAdView *amazonAdView;

@end

@implementation ControlPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.bennerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.bennerView.rootViewController = self;
    [self.bennerView loadRequest:[GADRequest request]];

    [self.amazonAdView setHorizontalAlignment:AmazonAdHorizontalAlignmentCenter];
    [self.amazonAdView setVerticalAlignment:AmazonAdVerticalAlignmentFitToContent];
    
    // Register the ViewController with the delegate to receive callbacks.
    self.amazonAdView.delegate = self;
    
    //Set the ad options and load the ad
    AmazonAdOptions *options = [AmazonAdOptions options];
    options.isTestRequest = YES;
    [self.amazonAdView loadAd:options];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AmazonAdViewDelegate

- (UIViewController *)viewControllerForPresentingModalView
{
    return self;
}

- (void)adViewDidLoad:(AmazonAdView *)view
{
    // Add the newly created Amazon Ad view to our view.
    [self.view addSubview:view];
    NSLog(@"Ad loaded");
}

- (void)adViewDidFailToLoad:(AmazonAdView *)view withError:(AmazonAdError *)error
{
    NSLog(@"Ad Failed to load. Error code %d: %@", error.errorCode, error.errorDescription);
}

- (void)adViewWillExpand:(AmazonAdView *)view
{
    NSLog(@"Ad will expand");
    // Save orientation so when our ad collapses we can reload an ad
    // Also useful if you need to programmatically rearrange view on orientation change
    
}

- (void)adViewDidCollapse:(AmazonAdView *)view
{
    NSLog(@"Ad has collapsed");
    // Check for if the orientation has changed while the view disappeared.
    
}

@end
