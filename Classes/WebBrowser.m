//
//  WebBrowser.m
//  iTransmission
//
//  Created by Lion User on 29/01/2013.
//
//

#import "WebBrowser.h"

@interface WebBrowser ()

@end

@implementation WebBrowser

@synthesize webTitle;
@synthesize webView;
@synthesize urlbar;
@synthesize magnet;
@synthesize torrent;
@synthesize controller;
@synthesize libtransmission;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil: (UINavigationController *)navigationController: (Controller *)transmission
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.controller = navigationController;
        self.libtransmission = transmission;
    }
    return self;
}

- (IBAction)go:(id)sender
{
    NSArray *sites = @[@"http://www.clearbits.net", @"http://www.publicdomaintorrents.info", @"http://www.legittorrents.info", @"http://bt.etree.org", @"http://www.linuxtracker.org", @"http://www.google.com", @"http://www.dropbox.com", @"http://www.box.com", @"http://www.drive.google.com"];
    NSString *urlToOpen = urlbar.text;
    for (NSString *str in sites){
        if ([urlToOpen isEqualToString:str]){
            NSURL *urlRequest = [NSURL URLWithString:urlToOpen];
            NSURLRequest *request = [NSURLRequest requestWithURL:urlRequest];
            urlbar.text = [urlRequest absoluteString];
            [webView loadRequest:request];
            
            // load request
            [webView loadRequest:request];
            
            // make network icon visible
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        }
        else{
            //url user entered is not one of the 5 urls
        }
    }
   
}

- (void)viewDidLoad
{
   [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // go to google.com
    NSURL *urlRequest = [NSURL URLWithString:@"http://www.bluedownloader.weebly.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlRequest];

    // set text bar
    urlbar.text = [urlRequest absoluteString];
    
    // load request
    [webView loadRequest:request];
    
    // show loading icon
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestedURL = [request URL];
    NSString *scheme = [requestedURL scheme];
    NSString *fileExtension = [requestedURL pathExtension];
    
    if(navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        // make network icon visible
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        if([scheme isEqualToString:@"magnet"])
        {
            self.magnet = [requestedURL absoluteString];
            
            NSLog(@"Magnet");
            
            // add magnet
            [self.libtransmission addTorrentFromManget:[self magnet]];
            
            // close view controller
            [self.controller popViewControllerAnimated:YES];
        }
        
        else if([fileExtension isEqualToString:@"torrent"])
        {
            self.torrent = [requestedURL absoluteString];
            
            NSLog(@"Torrent");
            
            // add torrent
            [self.libtransmission addTorrentFromURL:[self torrent]];
            
            // close view controller
            [self.controller popViewControllerAnimated:YES];
        }
    }
    
    return TRUE;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // update urlbar
    urlbar.text = webView.request.URL.absoluteString;
    
    // make the loading icon disappear
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
