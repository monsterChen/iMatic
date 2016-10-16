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
#import "XFSegementView.h"
#import "channelCellBtn.h"
#import "channelAll.h"
#import "DBManager.h"
#import "EGOCache.h"

@interface ControlPanelViewController ()<AmazonAdViewDelegate, GADBannerViewDelegate, TouchLabelDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@property (weak, nonatomic) IBOutlet AmazonAdView *amazonAdView;

@property (strong, nonatomic) XFSegementView *segementView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionnView;

@property (weak, nonatomic) IBOutlet channelAll *all_BTN;

@property (strong, nonatomic) NSMutableArray *listArray;

@end

@implementation ControlPanelViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    self.listArray = [[[DBManager shareInstance] queryChannelBtnName:self.channelCount isWifi:self.isWiFi] mutableCopy];
    [self.collectionnView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // set up Nav button
    [super genUINavigationLeftBcakButton:[UIImage imageNamed:@"back"]];
    //[super genUINavigationRightButton:[UIImage imageNamed:@"setting"] andSize:CGSizeMake(20, 20) andEvent:@selector(settingMethod)];
    
    //set up segmentView
    self.segementView = [[XFSegementView alloc]initWithFrame:CGRectMake(36, 114, [UIScreen mainScreen].bounds.size.width-72, 30)];
    self.segementView.titleArray = @[@"Basic",@"Group"];
    self.segementView.titleColor = [UIColor colorWithRed:193.0/255 green:196.0/255 blue:196.0/255 alpha:1.0];
    self.segementView.scrollLineColor = [UIColor colorWithRed:86.0/255 green:193.0/255 blue:200.0/255 alpha:1.0];
    
    self.segementView.titleSelectedColor = [UIColor colorWithRed:94.0/255 green:189.0/255 blue:197.0/255 alpha:1.0];
    [self.segementView setBackgroundColor:[UIColor colorWithRed:242.0/255 green:243.0/255 blue:244.0/255 alpha:1.0]];
    self.segementView.touchDelegate = self;
    [self.view addSubview:self.segementView];
    
    // set ControlPanelViewController BackgroundColor
    [self.view setBackgroundColor:[UIColor colorWithRed:242.0/255 green:243.0/255 blue:244.0/255 alpha:1.0]];
    [self.collectionnView setBackgroundColor:[UIColor colorWithRed:242.0/255 green:243.0/255 blue:244.0/255 alpha:1.0]];
    
    // set up amazonAdView Alignment
    [self.amazonAdView setHorizontalAlignment:AmazonAdHorizontalAlignmentCenter];
    [self.amazonAdView setVerticalAlignment:AmazonAdVerticalAlignmentFitToContent];
    
    // Register the ViewController with the delegate to receive callbacks.
    self.amazonAdView.delegate = self;
    
    //Set the ad options and load the ad
    AmazonAdOptions *options = [AmazonAdOptions options];
    options.isTestRequest = YES;
    [self.amazonAdView loadAd:options];
    
    // set all_BTN is visual
    self.all_BTN.hidden = NO;
    
    self.listArray = [[[DBManager shareInstance] queryChannelBtnName:self.channelCount isWifi:self.isWiFi] mutableCopy];
    [[EGOCache globalCache] setString:self.channelCount forKey:@"channelCount"];
    [[EGOCache globalCache] setString:(self.isWiFi ? @"1":@"0") forKey:@"isWiFi"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark settring method

- (void)settingMethod {
    
}

#pragma mark GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {

    NSLog(@"admob success");
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    
    NSLog(@"admob error");
    /**
     *  if admob fail then load amazonAd
     */
    AmazonAdOptions *options = [AmazonAdOptions options];
    options.isTestRequest = YES;
    [self.amazonAdView loadAd:options];
}


#pragma mark AmazonAdViewDelegate

- (UIViewController *)viewControllerForPresentingModalView{
    return self;
}

- (void)adViewDidLoad:(AmazonAdView *)view{
    // Add the newly created Amazon Ad view to our view.
    
    [self.view addSubview:view];
    NSLog(@"Ad loaded");
}

- (void)adViewDidFailToLoad:(AmazonAdView *)view withError:(AmazonAdError *)error{
    
    NSLog(@"Ad Failed to load. Error code %d: %@", error.errorCode, error.errorDescription);
    /**
     *  if amazonAd fail，then load admob
     */
    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    [self.bannerView loadRequest:[GADRequest request]];
}

- (void)adViewWillExpand:(AmazonAdView *)view{
    
    NSLog(@"Ad will expand");
    // Save orientation so when our ad collapses we can reload an ad
    // Also useful if you need to programmatically rearrange view on orientation change
    
}

- (void)adViewDidCollapse:(AmazonAdView *)view {
    NSLog(@"Ad has collapsed");
    // Check for if the orientation has changed while the view disappeared.
    
}

#pragma mark XFSegementViewDelegate
- (void)touchLabelWithIndex:(NSInteger)index {
    
    if (index == 0) {
        // basic command
        self.all_BTN.hidden = NO;
        
        [self.collectionnView reloadData];
    }else if(index == 1) {
        //groud command
        self.all_BTN.hidden = YES;
        
        [self.collectionnView reloadData];
    }
}

#pragma mark UICollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (self.all_BTN.hidden) {
        return 0;
    }else {
        return [self.channelCount intValue];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"channelCellBtn";
    
    channelCellBtn *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.labelText.text = [self.listArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    channelCellBtn *cell = (channelCellBtn *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [cell updateChannelStatus];
}



@end
