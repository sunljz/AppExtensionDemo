//
//  ViewController.m
//  AppExtensionDemo
//
//  Created by sun on 14-7-22.
//  Copyright (c) 2014年 sun. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()
            
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTouch:(id)sender {
    NSArray *itemArray = @[[UIImage imageNamed:@"1.jpg"],@"demoLogo"];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:itemArray applicationActivities:nil];
    [activityViewController setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError * error){
        
        if([returnedItems count] > 0){
            
            NSExtensionItem* extensionItem = [returnedItems firstObject];
            
            NSItemProvider* imageItemProvider = [[extensionItem attachments] firstObject];
            
            if([imageItemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]){
                
                [imageItemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(UIImage *item, NSError *error) {
                    
                    if(item && !error){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.imageView setImage:item];
                            
                        }); 
                        
                    } 
                    
                }]; 
                
                
                
            } 
            
        } 
        
    }];
    
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
