//
//  DownloadManager.m
//  auchinesemedia
//
//  Created by Yi Chen on 3/03/2014.
//  Copyright (c) 2014 ChenYi. All rights reserved.
//

#import "DownloadManager.h"

#define kAppIconSize 48

@interface DownloadManager ()
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;
@end


@implementation DownloadManager


#pragma mark

DownloadManager* instance;
+ (DownloadManager*)sharedInstance
{
    if (instance == nil)
    {
        instance = [[DownloadManager alloc] init];
    }
    return instance;
}


- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.appRecord.image]];
    
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    self.imageConnection = conn;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
//    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
        NSString* fileName = [self.appRecord.image lastPathComponent];
        NSArray* stringArray = [fileName componentsSeparatedByString:@"?"];
        NSString* imageName = [stringArray objectAtIndex:0];
        NSString *filePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:imageName];
        [self.activeDownload writeToFile:filePath atomically:YES];

    
//    if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
//    {
//        CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
//        UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
//        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//        [image drawInRect:imageRect];
//        self.appRecord.appIcon = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    }
//    else
//    {
//        self.appRecord.appIcon = image;
//    }
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
        self.completionHandler();
}

@end
