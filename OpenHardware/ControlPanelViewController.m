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
#import "CommandCode.h"
#import "EGOManager.h"

#import "AppDelegate.h"

@interface ControlPanelViewController ()<AmazonAdViewDelegate, GADBannerViewDelegate, TouchLabelDelegate, UICollectionViewDelegate, UICollectionViewDataSource, GCDAsyncSocketDelegate> {

    GCDAsyncSocket *clientStock;
    NSString *_host;
    NSString *_port;
    
    NSInteger _count;
}

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@property (weak, nonatomic) IBOutlet AmazonAdView *amazonAdView;

@property (strong, nonatomic) XFSegementView *segementView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionnView;

@property (weak, nonatomic) IBOutlet channelAll *all_BTN;

@property (strong, nonatomic) NSMutableArray *listArray;

@property (strong, nonatomic) NSArray *commandCode_ON;

@property (strong, nonatomic) NSArray *commandCode_OFF;


@property (nonatomic, assign) BOOL isWifiCheck_16;

@property (nonatomic, assign) BOOL isWifiALl_ON_16;

@property (nonatomic, assign) BOOL isSingleClick_16;

@property (nonatomic,retain) NSMutableArray *stateArray;

@end



@implementation ControlPanelViewController

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self.segementView selectLabelWithIndex:0];
    
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
    
    // initial connection info
    
    self.isWifiCheck_16 = NO;
    self.isSingleClick_16 = NO;
    self.isWifiALl_ON_16 = NO;
    /**
     *  初始化stateArray
     */
    self.stateArray = [NSMutableArray array];
    for(NSInteger i = 0; i < 16; i++) {
        [self.stateArray addObject:@"0"];
    }
    
    self.commandCode_ON = [CommandCode initCommaneCode_ON:self.channelCount isWifi:self.isWiFi];
    
    self.commandCode_OFF = [CommandCode initCommaneCode_OFF:self.channelCount isWifi:self.isWiFi];
    
    NSArray *conn = [[DBManager shareInstance] queryIP_and_port:self.channelCount isWifi:self.isWiFi];
    _host = [conn objectAtIndex:0];
    _port = [conn objectAtIndex:1];
    
    /**
     *  创建socket连接
     */
    clientStock = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [clientStock connectToHost:_host onPort:[_port intValue] withTimeout:2 error:nil];

    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.clientStock = clientStock;
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
    
    [self checkAllCellState];
    
    if (index == 0) {
        // basic command
        self.all_BTN.hidden = NO;
        
        self.listArray = [[[DBManager shareInstance] queryChannelBtnName:self.channelCount isWifi:self.isWiFi] mutableCopy];
        
        [self.collectionnView reloadData];
    }else if(index == 1) {
        //groud command
        self.all_BTN.hidden = YES;
        
        self.listArray = [[DBManager shareInstance] queryGroupNameArray:self.channelCount isWifi:self.isWiFi];
        
        [self.collectionnView reloadData];
    }
}

#pragma mark UICollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (self.all_BTN.hidden) {
        return [self.listArray count];
    }else {
        return [self.channelCount intValue];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"channelCellBtn";
    
    channelCellBtn *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.labelText.text = [self.listArray objectAtIndex:indexPath.row];
    cell.index = indexPath.row;
    
    // channel-16 wifi
    if ([self.channelCount isEqualToString:@"16"] && !self.all_BTN.hidden) {
        
        if ([[self.stateArray objectAtIndex:indexPath.row] isEqualToString:@"1"]) {
            
            cell.status = CHANNEL_ON;
        }else {
            
            cell.status = CHANNEL_OFF;
        }
    }
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    channelCellBtn *cell = (channelCellBtn *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (clientStock.isConnected) {
        //channel-8
        if ([self.channelCount isEqualToString:@"8"]) {
            //single button
            if (! self.all_BTN.hidden) {
                
                [self sendCommand:cell];
                [cell updateChannelStatus];
                [self cellStateWithAllBtnUpdate];
            }else {
                
                [self sendCommandGroup:cell];
                [cell updateChannelStatus];
            }
        }else {
        
            //chennel-16
            if (! self.all_BTN.hidden) {
                
                [self sendCommand_channel_16:cell];
                [cell updateChannelStatus];
                
                //检测16channel allBtn是否需要更新
                if (self.isWiFi) {
                    
                    if (cell.status == CHANNEL_ON) {
                        [self.stateArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
                    }else {
                        [self.stateArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
                    }
                }
                
                [self cellStateWithAllBtnUpdate];
            }
        }
    }else {
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showInfoWithStatus:@"Connecting"];
        
        [clientStock connectToHost:_host onPort:[_port intValue] withTimeout:2 error:nil];
    }
    
    //[cell updateChannelStatus];
}

#pragma mark send command channel-8
- (void)sendCommand:(id)data {
    
    channelCellBtn *cell = (channelCellBtn *)data;
    
    if (cell.status == CHANNEL_ON) {
        
        NSString *code = [self.commandCode_OFF objectAtIndex:cell.index];
        //NSLog(@"channel-8-off %@", code);
        [clientStock writeData:[CommandCode decode8:code] withTimeout:2 tag:-1];
        [clientStock readDataWithTimeout:2 tag:-1];
        
    }else if(cell.status == CHANNEL_OFF) {
        
        NSString *code = [self.commandCode_ON objectAtIndex:cell.index];
        //NSLog(@"channel-8-on %@", code);
        [clientStock writeData:[CommandCode decode8:code] withTimeout:2 tag:-1];
        [clientStock readDataWithTimeout:2 tag:-1];
    }
}

- (void)sendCommandGroup:(id)data {
    
    channelCellBtn *cell = (channelCellBtn *)data;
    
    NSMutableArray *array = [[DBManager shareInstance] queryGroupButton:cell.labelText.text channel:self.channelCount isWifi:self.isWiFi];
    
    for(GroupModel *model in array) {
        
        if (model.selectState == isSelect) {
            
            if (model.state == isOn) {
                //NSLog(@"channel-8-group-on %@", [self.commandCode_ON objectAtIndex:cell.index]);
                [clientStock writeData:[CommandCode decode8:[self.commandCode_ON objectAtIndex:cell.index]] withTimeout:2 tag:-1];
                [clientStock readDataWithTimeout:2 tag:-1];
                
            }else if(model.state == isOFF) {
                //NSLog(@"channel-8-group-off %@", [self.commandCode_ON objectAtIndex:cell.index]);
                [clientStock writeData:[CommandCode decode8:[self.commandCode_OFF objectAtIndex:cell.index]] withTimeout:2 tag:-1];
                [clientStock readDataWithTimeout:2 tag:-1];
            }
        }
    }
}

- (void)checkAllCellState {

    if (clientStock.isConnected) {
        
        if ([self.channelCount isEqualToString:@"8"]) {
            
            [clientStock writeData:[CommandCode decode8:checkStateChannel_8] withTimeout:2 tag:-1];
            [clientStock readDataWithTimeout:3 tag:-1];
            
        }else {
        
            self.isWifiCheck_16 = YES;
            self.isSingleClick_16 = NO;
            self.isWifiALl_ON_16 = NO;
            
            if (self.isWiFi) {
                
                [clientStock writeData:[CommandCode decode16:checkStateChannel_16] withTimeout:2 tag:-1];
                [clientStock readDataWithTimeout:3 tag:-1];
            }else {
                
                [clientStock writeData:[CommandCode decode16:checkStateChannel_16_wifi] withTimeout:2 tag:-1];
                [clientStock readDataWithTimeout:3 tag:-1];
            }
        }
    }
}

#pragma mark 根据返回状态更新按钮状态
#pragma mark channel-8
- (void)updateChannelState:(NSString *)str {

    for(NSInteger i = 0; i < 8; i++) {
        
        channelCellBtn *cell = (channelCellBtn *)[self.collectionnView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if([str characterAtIndex:7 - i] - 48 == 1) {
            
            [cell setStatus:CHANNEL_ON];
            
            _count++;
        }else {
            
            [cell setStatus:CHANNEL_OFF];
            
            _count--;
        }
    }
    
    if (_count == 8) {
        
        self.all_BTN.btnStatus = ALL_ON;
    }else {
        
        self.all_BTN.btnStatus = ALL_OFF;
    }
    
    _count = 0;
}

- (void)updateSimpleButtonState:(NSData *)data {

    Byte *tmp = [data bytes];
    
    if (tmp[1] == 248) {
        
        if (tmp[2] == 136) {
            //全部点亮
            self.all_BTN.btnStatus = ALL_ON;
            NSString *all_ON = [CommandCode decimalTOBinary:255 backLength:8];
            [self updateChannelState:all_ON];
        }else if (tmp[2] == 128){
            //全部关闭
            self.all_BTN.btnStatus = ALL_OFF;
            NSString *all_OFF = [CommandCode decimalTOBinary:0 backLength:8];
            [self updateChannelState:all_OFF];
        }
    }
}

#pragma mark 16-channel
- (void)sendCommand_channel_16:(id)data {

    channelCellBtn *cell = (channelCellBtn *)data;
    
    self.isSingleClick_16 = YES;
    
    if (cell.status == CHANNEL_ON) {
        
        NSString *code = [self.commandCode_OFF objectAtIndex:cell.index];
        //NSLog(@"channel-16-off %@", code);
        [clientStock writeData:[CommandCode decode16:code] withTimeout:2 tag:-1];
        [clientStock readDataWithTimeout:2 tag:-1];
    }else if (cell.status == CHANNEL_OFF) {
        
        NSString *code = [self.commandCode_ON objectAtIndex:cell.index];
        //NSLog(@"channel-16-on %@", code);
        [clientStock writeData:[CommandCode decode16:code] withTimeout:2 tag:-1];
        [clientStock readDataWithTimeout:2 tag:-1];
    }
}

- (void)updateChannelState:(NSString *)str type:(NSInteger)type {
    
    if (type == 6) {
        
        for(NSInteger i = 0; i < 8; i++) {
            //str->7 对应 cell->0 如此类推
            channelCellBtn *cell = (channelCellBtn *)[self.collectionnView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            if ([str characterAtIndex:7 - i] - 48 == 1) {
                
                [self.stateArray replaceObjectAtIndex:i withObject:@"1"];
                [cell setStatus:CHANNEL_ON];
            }else {
            
                [self.stateArray replaceObjectAtIndex:i withObject:@"0"];
                [cell setStatus:CHANNEL_OFF];
            }
        }
    }else if (type == 5) {
        
        for(NSInteger i = 8; i < 16; i++) {
            //str->7 对应cell->8
            channelCellBtn *cell = (channelCellBtn *)[self.collectionnView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            if ([str characterAtIndex:15 - i] == 1) {
                
                [self.stateArray replaceObjectAtIndex:i withObject:@"1"];
                [cell setStatus:CHANNEL_ON];
            }else {
                
                [self.stateArray replaceObjectAtIndex:i withObject:@"0"];
                [cell setStatus:CHANNEL_OFF];
            }
        }
    }
}

- (void)cellStateWithAllBtnUpdate {
    
    NSInteger cellCount = 0;
    
    for (NSInteger i = 0; i < 16; i++) {
        
        if ([[self.stateArray objectAtIndex:i] isEqualToString:@"1"]) {
            cellCount++;
        }
    }
    
    if (self.all_BTN.btnStatus == ALL_ON) {
        
        if (cellCount < 16) {
            
            self.all_BTN.btnStatus = ALL_OFF;
        }else {
            
            self.all_BTN.btnStatus = ALL_ON;
        }
        
    }else {
        
        if (cellCount == 16) {
            self.all_BTN.btnStatus = ALL_ON;
        }
    }
}

- (void)updateWifiChannelSate:(NSString *)str type:(NSInteger)type {

    if (type == 1) {
        
        for(NSInteger i = 0; i < 8; i++) {
            //str－>7对应 cell->0如此类推
            channelCellBtn *cell = (channelCellBtn *)[self.collectionnView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            if ([str characterAtIndex:7 - i] == 1) {
                
                [self.stateArray replaceObjectAtIndex:i withObject:@"1"];
                [cell setStatus:CHANNEL_ON];
            }else {
                
                [self.stateArray replaceObjectAtIndex:i withObject:@"0"];
                [cell setStatus:CHANNEL_OFF];
            }
        }
    }else if(type == 2) {
        
        for(NSInteger i = 8; i < 16; i++) {
            //str->7对应cell->8
            channelCellBtn *cell = (channelCellBtn *)[self.collectionnView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            if ([str characterAtIndex:15 - i] == 1) {
                
                [self.stateArray replaceObjectAtIndex:i withObject:@"1"];
                [cell setStatus:CHANNEL_ON];
            }else {
                
                [self.stateArray replaceObjectAtIndex:i withObject:@"0"];
                [cell setStatus:CHANNEL_OFF];
            }
        }
    }
}

- (void)checkCellWithWifi {
    
    if (self.all_BTN.btnStatus == ALL_ON) {
        /**
         *  触发allBtn开启，修改各个Cell状态为ON
         */
        for (NSInteger i = 0; i < 16; i++) {
            
            channelCellBtn *cell = (channelCellBtn *)[self.collectionnView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            [self.stateArray replaceObjectAtIndex:i withObject:@"1"];
            
            [cell setStatus:CHANNEL_ON];
        }
    }else {
        
        /**
         *  触发allBtn关闭，先检查全部按钮是否都处于ON状态，如果是则修改cell按钮状态为OFF
         */
        NSInteger count = 0;
        
        for (NSInteger i = 0; i < 16; i++) {
            /*
             BTNCollectionViewCell *cell = (BTNCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
             
             if (cell.state == STATE_ON) {
             count++;
             }
             */
            if([[self.stateArray objectAtIndex:i] isEqualToString:@"1"]) {
                
                count ++;
            }
        }
        //NSLog(@"count->%d", count);
        if (count == 16) {
            
            for (NSInteger i = 0; i < 16; i++) {
                
                channelCellBtn *cell = (channelCellBtn *)[self.collectionnView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                
                [cell setStatus:CHANNEL_OFF];
            }
        }
    }

}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    if (!self.all_BTN.hidden) {
        
        Byte *tmp = [data bytes];
        
        if([self.channelCount isEqualToString:@"8"]) {
            
            if(tmp[1] == 255) {
                
                NSString *str = [CommandCode decimalTOBinary:tmp[2] backLength:8];
                
                [self updateChannelState:str];
            }else {
                
                [self updateSimpleButtonState:data];
            }
        }else {
        
            if (!self.isWiFi) {
                
                if (tmp[0] == 40) {
                    
                    for(int i=0; i<8; i++) {
                        if (i == 5) {
                            NSString *str = [CommandCode decimalTOBinary:tmp[i] backLength:8];
                            [self updateChannelState:str type:5];
                            //NSLog(@"5->%@", str);
                        }
                        if (i == 6) {
                            NSString *str = [CommandCode decimalTOBinary:tmp[i] backLength:8];
                            [self updateChannelState:str type:6];
                            //NSLog(@"6->%@", str);
                        }
                        //NSLog(@"%d", tmp[i]);
                    }
                    
                    //检测是否更新allBtn
                    [self cellStateWithAllBtnUpdate];
                }
            }else if(self.isWiFi && self.isWifiCheck_16){
            
                if (self.isWifiCheck_16) {
                    
                    if (self.isSingleClick_16) {
                        
                        Byte *tmp = [data bytes];
                        NSString *str1 = [CommandCode decimalTOBinary:tmp[1] backLength:8];
                        
                        [self updateWifiChannelSate:str1 type:2];
                        
                        NSString *str2 = [CommandCode decimalTOBinary:tmp[2] backLength:8];
                        [self updateWifiChannelSate:str2 type:1];
                        
                        [self cellStateWithAllBtnUpdate];
                    }else {
                        
                        [self checkCellWithWifi];
                        
                        self.isWifiCheck_16 = NO;
                    }
                }
            }
        }
    }
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:@"Connect Success"];
    
    if (! self.all_BTN.hidden) {
        
        [self checkAllCellState];
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    
    if (err) {
        
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showErrorWithStatus:@"Connect Error"];
    }
}

@end
