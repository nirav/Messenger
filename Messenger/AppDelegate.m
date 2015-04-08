//
//  AppDelegate.m
//  Messenger
//
//  Created by Nirav Savjani on 10/1/14.
//  Copyright (c) 2014 Nirav Savjani. All rights reserved.
//

#import "AppDelegate.h"

#import "WebViewJavascriptBridge.h"

#import <WebKit/WebKit.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (nonatomic, strong) WebView *webView;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [self openMessengerWindow];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
  [self.window makeKeyAndOrderFront:nil];
  return YES;
}

- (void)openMessengerWindow {
  self.window.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
  self.window.titleVisibility = NSWindowTitleHidden;
  self.window.titlebarAppearsTransparent = YES;
  
  NSURL *url = [NSURL URLWithString:@"http://www.messenger.com"];
  NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
  
  self.webView = [[WebView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)
                                      frameName:@"main"
                                      groupName:@"main"];
  self.window.contentView = self.webView;
  
  [[self.webView mainFrame] loadRequest:urlRequest];
  [self.window setContentView:self.webView];
  self.webView.policyDelegate = self;
  [[self.window standardWindowButton:NSWindowCloseButton] setFrame:NSZeroRect];
  [[self.window standardWindowButton:NSWindowMiniaturizeButton]setFrame:NSZeroRect];
  [[self.window standardWindowButton:NSWindowZoomButton] setFrame:NSZeroRect];

  [self.window setExcludedFromWindowsMenu:YES];
  
  self.webView.frameLoadDelegate = self;

}

#pragma mark - Web View

- (void)webView:(WebView *)sender decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener {
  if( [sender isEqual:self.window.contentView] ) {
    [listener use];
  }
  else {
    [[NSWorkspace sharedWorkspace] openURL:[actionInformation objectForKey:WebActionOriginalURLKey]];
    [listener ignore];
  }
}

- (void)webView:(WebView *)sender decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id<WebPolicyDecisionListener>)listener {
  [[NSWorkspace sharedWorkspace] openURL:[actionInformation objectForKey:WebActionOriginalURLKey]];
  [listener ignore];
}


@end
