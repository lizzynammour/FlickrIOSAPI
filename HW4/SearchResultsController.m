//
//  SearchResultsController.m
//  HW4
//
//  Created by Lizzy Nammour on 10/17/15.
//  Copyright (c) 2015 enammour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchResultsController.h"

@interface SearchResultsController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic) NSMutableArray *searched_images;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property(nonatomic) NSData *imageData;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@end

@implementation SearchResultsController


- (void)viewDidLoad {
  self.activity  = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [super viewDidLoad];
    [self.activity startAnimating];
    [self loadImagesFromFlickr];
    [self.activity stopAnimating];
}

- (void)loadImagesFromFlickr {
    // See the defined URL above.
    NSURL *url = [NSURL URLWithString:self.text];
    // Create a MutableURL request with the URL we just made.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // Begin a URL session with the request and then handle the recieved data.
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:
      ^(NSData *  data, NSURLResponse * response, NSError *  error) {
          // See blocks in the lecture slides.
          NSMutableDictionary *dictionary =
          [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
          self.searched_images = [[[dictionary objectForKey:@"photos"] objectForKey:@"photo"] mutableCopy];
                   
          _tableView.delegate = self;
          _tableView.dataSource = self;
          [_tableView reloadData];
          
      }]  resume];
    
    ;
    
    //**** Remember to include this resume snippet here or else the request won't be sent.
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
       return self.searched_images.count;
}

 -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     
     NSMutableDictionary *image = [self.searched_images objectAtIndex:indexPath.row];
     CGFloat height = [[image objectForKey:@"height"] intValue];
 
     return (height + 200);
     
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // We previously set the cell identifier in the storyboard.
      NSLog(@"called cell");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    // We set the tag in the storyboard.
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:2];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, 0.0);
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageView.image = blank;
    NSMutableDictionary *image = [self.searched_images objectAtIndex:indexPath.row];
     NSString *imageUrl = [image objectForKey:@"url_m"];
      label.text = [image objectForKey:@"title"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //[self.activity startAnimating];
       
        self.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
            
 imageView.clipsToBounds = YES;
          
            imageView.image = [UIImage imageWithData:self.imageData];
           
                        
        });
    });
    
    return cell;
}




@end