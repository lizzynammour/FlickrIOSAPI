//
//  SearchController.m
//  HW4
//
//  Created by Lizzy Nammour on 10/17/15.
//  Copyright (c) 2015 enammour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchController.h"
#import "SearchResultsController.h"

#define flickrURL @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=72fd9a604245c4205627725f469531fc&text=***INSERT QUERY HERE***&extras=url_m&format=json&nojsoncallback=1"
@interface SearchController()

@property (strong, nonatomic) IBOutlet UITextField *text;
@end
@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
  }

- (IBAction) searchButtonPressed:(id) sender {
    [self performSegueWithIdentifier:@"search" sender:self];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"search"]) {
      SearchResultsController *view = (SearchResultsController *)segue.destinationViewController;
        view.text = [flickrURL stringByReplacingOccurrencesOfString:@"***INSERT QUERY HERE***" withString: self.text.text];
    }
}

@end