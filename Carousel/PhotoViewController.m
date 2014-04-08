//
//  PhotoViewController.m
//  Carousel
//
//  Created by Abhineet on 08/04/14.
//  Copyright (c) 2014 LogTera. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *photoNameLabel;

@end

@implementation PhotoViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(140,220 ,50,50);
    //spinner.tintColor = [UIColor whiteColor];
    [self.view addSubview:spinner];
    
    [spinner startAnimating];
    
    
    
    
    //MWPhoto *photoFetched = [[MWPhoto alloc]init];
    NSURL *url = [NSURL URLWithString:self.photoURLString];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue  *queue;
    if ( queue == nil )
    {
        queue = [[NSOperationQueue alloc] init];
    }
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse * resp, NSData     *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            if ( error == nil && data )
                            {
                                UIImage *urlImage = [[UIImage alloc] initWithData:data];
                                self.imageView.image = urlImage;
                                [spinner stopAnimating];
                            }
                        });
     }];
    

    
    self.photoNameLabel.text = self.photoName;
    
    
	// Do any additional setup after loading the view.
}
- (IBAction)backPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
