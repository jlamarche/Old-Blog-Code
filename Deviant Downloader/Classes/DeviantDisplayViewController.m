//
//  DeviantDisplayViewController.m
//  Deviant Downloader
//
//  Created by jeff on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DeviantDisplayViewController.h"
#import "DeviantDisplayCell.h"
#import "CJSONDeserializer.h"
#import "NSString-search.h"
#import "ZoomableImageViewController.h"

@interface DeviantDisplayViewController()
@property (nonatomic, retain) NSMutableData *receivedData;
- (void)loadNextSet;
@end

@implementation DeviantDisplayViewController
@synthesize deviantName;
@synthesize loadCell;
@synthesize downloads;
@synthesize receivedData;
- (void)loadNextSet
{

    NSString *urlBase = [NSString stringWithFormat:@"http://%@.deviantart.com/global/difi/?c[]=Resources;htmlFromQuery;gallery:%@ sort:time,%d,24,thumb150,artist:0&t=json", deviantName, deviantName, current];
    NSURL *url = [NSURL URLWithString:[urlBase stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *con =[[NSURLConnection alloc] initWithRequest:req 
                                                          delegate:self];
    if (con) 
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData=data;
        [data release];
    } 
    else 
        NSLog(@"Thou shalt do real error checking!");
    
    [req release];
    current += 24;
}
- (void)viewDidLoad
{
    current = 0;
    self.title = NSLocalizedString(@"Downloads", @"");
    self.downloads = [NSMutableArray array];
    [self loadNextSet];    
    
}
- (void)viewDidUnload 
{
    [super viewDidUnload];
    self.loadCell = nil;
}
- (void)dealloc
{
    [deviantName release];
    [loadCell release];
    [downloads release];
    [receivedData release];
    [super dealloc];
}
#pragma mark -
#pragma mark Table View Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [downloads count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    DeviantDisplayCell *cell = (DeviantDisplayCell *)[tableView dequeueReusableCellWithIdentifier:[DeviantDisplayCell reuseIdentifier]];
    if (cell == nil) 
    {
        [[NSBundle mainBundle] loadNibNamed:@"DeviantDisplayCell" owner:self options:nil];
        cell = loadCell;
        self.loadCell = nil;
    }
    DeviantDownload *download = [downloads objectAtIndex:[indexPath row]];
    cell.cellLabel.text = download.filename;
    UIImage *cellImage = download.image;
    if (cellImage == nil)
    {
        [cell.cellSpinner startAnimating];
        download.delegate = self;
    }
    else
        [cell.cellSpinner stopAnimating];
    
    cell.cellImageView.image = cellImage;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviantDownload *download = [downloads objectAtIndex:[indexPath row]];
    ZoomableImageViewController *controller = [[ZoomableImageViewController alloc] init];
    controller.image = download.image;
    controller.title = download.filename;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma mark Deviant Download Delegate Methods
- (void)downloadDidFinishDownloading:(DeviantDownload *)download
{
    NSUInteger index = [downloads indexOfObject:download]; 
    NSUInteger indices[] = {0, index};
    NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:indices length:2];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    [path release];
    download.delegate = nil;
}
- (void)download:(DeviantDownload *)download didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
}
#pragma mark -
#pragma mark NSURLConnection Callbacks
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
    [receivedData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error 
{
    [connection release];
    NSLog(@"More real error checking, okay?");
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    
    NSError *error = nil;
    NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:receivedData error:&error];
    NSDictionary *difi = [dictionary objectForKey:@"DiFi"];
    NSArray *theDownloads = [[[[[[difi objectForKey:@"response"] objectForKey:@"calls"] objectAtIndex:0] objectForKey:@"response"] objectForKey:@"content"] objectForKey:@"resources"];
    
    BOOL loadNext = NO;
    for (NSArray *oneDownload in theDownloads)
    {
        NSString *payload = [oneDownload objectAtIndex:2];
        NSRange urlRange = [payload rangeAfterString:START_TOKEN toStartOfString:STOP_TOKEN];
        if (urlRange.location != NSNotFound)
        {
            NSString *imageURL = [payload substringWithRange:urlRange];
            DeviantDownload *download = [[DeviantDownload alloc] init];
            download.urlString = imageURL;
            if (![downloads containsObject:download])
                [downloads addObject:download];
            [download release];
            loadNext = YES;
        }
    }
    
    [self.tableView reloadData];
    [connection release];
    self.receivedData = nil;
    
    if (loadNext)
        [self loadNextSet];
    
    
}
@end

