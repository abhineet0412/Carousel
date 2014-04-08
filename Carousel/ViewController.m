//
//  ViewController.m
//  Carousel
//
//  Created by Abhineet on 07/04/14.
//  
//

#import "ViewController.h"
#import "PhotoViewController.h"

#define FlickrAPIKey @"01df915abb0e6cc420287c13e52e75c9"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property(nonatomic, strong) NSMutableArray *photoNames;
@property(nonatomic, strong) NSMutableArray *photoURLs;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photoNames = [NSMutableArray arrayWithCapacity:30];
    self.photoURLs = [NSMutableArray arrayWithCapacity:30];
  	// Do any additional setup after loading the view, typically from a nib.
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"profCollection"];
    
    [self loadFlickrPhotos];
}


- (void)loadFlickrPhotos
{
    //Build Request for flickr Api
    NSError* error;
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=10&format=json&nojsoncallback=1", FlickrAPIKey, @"Kishor"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    // URLResponse string & parse JSON
    NSData *jsonString = [NSData dataWithContentsOfURL:url];
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonString options:kNilOptions
                             error:&error];
    
    
    NSArray *photos = [[results objectForKey:@"photos"] objectForKey:@"photo"];
    for (NSDictionary *photo in photos) {
        
        //  Get title for  photo
        NSString *title = [photo objectForKey:@"title"];
        [_photoNames addObject:(title.length > 0 ? title : @"Untitled")];
        // Construct URL for photo.
        NSString *photoURLString = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
        [_photoURLs addObject:photoURLString];
        
    }

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoURLs.count; // number of collection cells
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
   
    
    static NSString *cellIdentifier = @"profCollection";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    cell.backgroundColor = [UIColor blackColor];
    
    if(cell == nil) {
        //cell = [[ProfileCollectionCell alloc] initW];
        NSLog(@"INSIDE ERROR NEED TO HANDLE");
        
    }
    cell.tag = indexPath.row;
    
    for (UIView *subview in [cell subviews]) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
        
        if ([subview isKindOfClass:[UILabel class]]) {
            [subview removeFromSuperview];
        }
        
    }
    
    
    
    
    
    UIImageView*  imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.clipsToBounds = YES;
    [cell addSubview:imageView];
    
    imageView.image = nil;
    
   
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.frame = CGRectMake(100,100 ,50,50);
        //spinner.tintColor = [UIColor whiteColor];
        [cell addSubview:spinner];
        
        [spinner startAnimating];
        
    
        
        
        //MWPhoto *photoFetched = [[MWPhoto alloc]init];
    NSURL *url = [NSURL URLWithString:[_photoURLs objectAtIndex:indexPath.row]];
    
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
                                imageView.image = urlImage;
                                [spinner stopAnimating];
                            }
                        });
     }];
        
        
        
    
        

        
    
        
    
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(9, cell.frame.size.height - 40, 120, 20)];
         title.text = [_photoNames objectAtIndex:indexPath.row];
    title.numberOfLines = 1;
    title.textColor = [UIColor whiteColor];
    
    [cell addSubview:title];
    
    
   
    return cell;
    
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    PhotoViewController  *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"photoView"];
    
    
    
    vc.photoURLString = [_photoURLs objectAtIndex:indexPath.row];
    vc.photoName  = [_photoNames objectAtIndex:indexPath.row];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
