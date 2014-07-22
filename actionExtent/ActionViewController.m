//
//  ActionViewController.m
//  actionExtent
//
//  Created by sun on 14-7-22.
//  Copyright (c) 2014年 sun. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface UIView (mmcCut)

/**
 *  截图
 *
 *  @return 图片
 */
- (UIImage *)cutTheLayerToImage;

@end


@interface ActionViewController ()

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property(strong,nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end

@implementation ActionViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get the item[s] we're handling from the extension context.
    
    // For example, look for an image and place it into an image view.
    // Replace this with something appropriate for the type[s] your extension supports.
    NSLog(@"app extent: I'm coming");
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeImage]) {
                // This is an image. We'll load it, then place it in our image view.
                __weak UIImageView *imageView = self.imageView;
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeImage options:nil completionHandler:^(UIImage *image, NSError *error) {
                    if(image) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [imageView setImage:image];
                        }];
                    }
                }];
                
                continue;
            }
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeText]) {
                __weak UILabel *label = self.label;
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeText options:nil completionHandler:^(id<NSSecureCoding> item, NSError *error) {
                    if (item) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            label.text = (NSString *)item;
                        }];
                    }
                }];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    UIImage *image = [_containerView cutTheLayerToImage];
    
    NSExtensionItem* extensionItem = [[NSExtensionItem alloc] init];
    
    [extensionItem setAttachments:@[[[NSItemProvider alloc] initWithItem:image typeIdentifier:(NSString*)kUTTypeImage]]];
    
    
    [self.extensionContext completeRequestReturningItems:@[extensionItem] completionHandler:nil];
}

- (IBAction)close:(id)sender {
    [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
}

@end

@implementation UIView (mmcCut)

- (UIImage *)cutTheLayerToImage {
    UIGraphicsBeginImageContext(self.layer.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
