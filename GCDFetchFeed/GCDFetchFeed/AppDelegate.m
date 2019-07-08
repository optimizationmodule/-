//
//  AppDelegate.m
//  GCDFetchFeed
//
//  Created by DaiMing on 16/1/19.
//  Copyright © 2016年 Starming. All rights reserved.
//

#import "AppDelegate.h"

#import "SMRootViewController.h"
#import "SMFeedListViewController.h"
#import "SMMapViewController.h"
#import "SMStyle.h"
#import "SMFeedModel.h"
#import "SMLagMonitor.h"
#import "SMCallTrace.h"
#import <Matrix.h>

@interface AppDelegate ()<MatrixPluginListenerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //这里是做卡顿监测
//    [[SMLagMonitor shareInstance] beginMonitor];
    [SMCallTrace start];
    [self setupMatrix];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //首页
    SMRootViewController *rootVC = [[SMRootViewController alloc] init];
//    UINavigationController *homeNav = [self styleNavigationControllerWithRootController:rootVC];
    UINavigationController *homeNav = [self styleNavigationControllerWithRootController:rootVC];
    UITabBarItem *homeTab = [[UITabBarItem alloc] initWithTitle:@"频道" image:nil tag:1];
    homeTab.titlePositionAdjustment = UIOffsetMake(0, -20);
    homeNav.tabBarItem = homeTab;
    
    //列表
    SMFeedModel *feedModel = [SMFeedModel new];
    feedModel.fid = 0;
    SMFeedListViewController *feedListVC = [[SMFeedListViewController alloc] initWithFeedModel:feedModel];
    UINavigationController *listNav = [self styleNavigationControllerWithRootController:feedListVC];
    UITabBarItem *listTab = [[UITabBarItem alloc] initWithTitle:@"列表" image:nil tag:2];
    listTab.titlePositionAdjustment = UIOffsetMake(0, -18);
    listNav.tabBarItem = listTab;
    
    //map
//    SMMapViewController *mapVC = [[SMMapViewController alloc] init];
//    UINavigationController *mapNav = [self styleNavigationControllerWithRootController:mapVC];
//    UITabBarItem *mapTab = [[UITabBarItem alloc] initWithTitle:@"地图" image:nil tag:2];
//    mapTab.titlePositionAdjustment = UIOffsetMake(0, -18);
//    mapNav.tabBarItem = mapTab;
    
    UITabBarController *tabBarC = [[UITabBarController alloc]initWithNibName:nil bundle:nil];
    tabBarC.tabBar.tintColor = [SMStyle colorPaperBlack];
    tabBarC.tabBar.barTintColor = [SMStyle colorPaperDark];
    UIView *shaowLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tabBarC.tabBar.frame), 0.5)];
    shaowLine.backgroundColor = [UIColor colorWithHexString:@"D8D7D3"];
    [tabBarC.tabBar addSubview:shaowLine];
    tabBarC.tabBar.shadowImage = [UIImage new];
    tabBarC.tabBar.clipsToBounds = YES;
    tabBarC.viewControllers = @[homeNav,listNav];
    
    self.window.rootViewController = tabBarC;
//    self.window.rootViewController = homeNav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupMatrix
{
    Matrix *matrix = [Matrix sharedInstance];
    MatrixBuilder *curBuilder = [[MatrixBuilder alloc] init];
    curBuilder.pluginListener = self; // pluginListener 回调 plugin 的相关事件
    
    WCCrashBlockMonitorPlugin *crashBlockPlugin = [[WCCrashBlockMonitorPlugin alloc] init];
    [curBuilder addPlugin:crashBlockPlugin]; // 添加卡顿和崩溃监控
    
    WCMemoryStatPlugin *memoryStatPlugin = [[WCMemoryStatPlugin alloc] init];
    [curBuilder addPlugin:memoryStatPlugin]; // 添加内存监控功能
    
    [matrix addMatrixBuilder:curBuilder];
    
    [crashBlockPlugin start]; // 开启卡顿和崩溃监控
    [memoryStatPlugin start];
}

- (UINavigationController *)styleNavigationControllerWithRootController:(UIViewController *)vc {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.tintColor = [SMStyle colorPaperBlack];
    nav.navigationBar.barTintColor = [SMStyle colorPaperDark];
    UIView *shaowLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(nav.navigationBar.frame), CGRectGetWidth(nav.navigationBar.frame), 0.5)];
    shaowLine.backgroundColor = [UIColor colorWithHexString:@"D8D7D3"];
    [nav.navigationBar addSubview:shaowLine];
    nav.navigationBar.translucent = NO;
    return nav;
}

//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    [SMCallTrace stopSaveAndClean];
//}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [SMCallTrace stopSaveAndClean];
}

#pragma Mark plugin delegate

- (void)onInit:(id<MatrixPluginProtocol>)plugin
{
    NSLog(@"Matrix init:%@",plugin);
}
- (void)onStart:(id<MatrixPluginProtocol>)plugin
{
    NSLog(@"Matrix start:%@",plugin);
}
- (void)onStop:(id<MatrixPluginProtocol>)plugin
{
    NSLog(@"Matrix stop:%@",plugin);
}
- (void)onDestroy:(id<MatrixPluginProtocol>)plugin
{
    NSLog(@"Matrix destory:%@",plugin);
}
- (void)onReportIssue:(MatrixIssue *)issue
{
    NSLog(@"Matrix issue:%@",issue);
}

@end
