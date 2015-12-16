
// zybug.com
// create by zybug


#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
    self.imageView.image = [[UIImage alloc] initWithContentsOfFile:pathStr];
    
}

- (IBAction)btnClick:(id)sender {
    
    [self upLoadImage];
    
}

- (void)upLoadImage {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    // 参数要写userId 
    [manager POST:@"http://127.0.0.1/img/new/upload.php" parameters:@{@"userId":@"123312"} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:pathStr];
        
        // fileName => 可以随便写
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"tupian.png" mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"msg:%@",responseObject[@"msg"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
    }];
    
    
}

@end
