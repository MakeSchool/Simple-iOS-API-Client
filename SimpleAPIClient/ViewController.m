//
//  ViewController.m
//  SimpleAPIClient
//
//  Created by Benjamin Encz on 19/09/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLSessionDelegate>

@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfiguration;

@end

@implementation ViewController

+ (NSURL *)authenticatedURLForURLString:(NSString *)urlString {
    NSString *username = @"Testuser";
    NSString *password = @"ü?--Öälschgf";
    
    NSString *authenticationQuery = [NSString stringWithFormat:@"?username=%@&password=%@", username, password];
    NSString * escapedQuery = [authenticationQuery stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *finalQuery = [urlString stringByAppendingString:escapedQuery];
    
    return [NSURL URLWithString:finalQuery];
}

- (void)activateBasicAuthWithUsername:(NSString *)username password:(NSString *)password {
    NSString *userPasswordString = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData * userPasswordData = [userPasswordString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64EncodedCredential = [userPasswordData base64EncodedStringWithOptions:0];
    NSString *authString = [NSString stringWithFormat:@"Basic %@", base64EncodedCredential];
    NSString *userAgentString = @"AppName/com.example.app (iPhone 5s; iOS 7.0.2; Scale/2.0)";
    
    self.sessionConfiguration.HTTPAdditionalHeaders = @{@"Accept": @"application/json",
                                            @"Accept-Language": @"en",
                                            @"Authorization": authString,
                                            @"User-Agent": userAgentString};

}

- (IBAction)signupPressed:(id)sender {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:[NSOperationQueue new]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/user"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *userPasswordDictionary = @{@"user":@"Testuser", @"password":@"ü?--Öälschgf"};
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userPasswordDictionary options:0 error:&error];
    if (error) {
        NSLog(@"Cannot serialize username and password");
        return;
    } else {
        [request setHTTPBody:jsonData];
    }

    NSURLSessionDataTask *jsonTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Failed to parse response" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            });
        } else if (responseStatusCode == 200) {
            NSError *jsonError = nil;
            NSArray *users = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSDictionary *user = users[0];
            NSString *username = user[@"username"];
            NSString *successMessage = [NSString stringWithFormat:@"User %@ has been created!", username];
            [self activateBasicAuthWithUsername:@"Testuser" password:@"ü?--Öälschgf"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Success!" message:successMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            });
        } else {
            NSError *jsonError = nil;
            NSDictionary *error = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSString *errorMessage = [NSString stringWithFormat:@"The following error ocurred: %@", error[@"error"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Error!" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            });
        }
    }];
    
    [jsonTask resume];
}

- (IBAction)getCandyButtonPressed:(id)sender {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:[NSOperationQueue new]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:3000/candy"]];
    NSURLSessionDataTask *getCandyTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
    
        if (responseStatusCode == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Success!" message:@"You got candy!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            });
        } else if (responseStatusCode == 401) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Wrong credentials!" message:@"You cannot get candy!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Oh oh!" message:@"Something when wrong!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            });
        }
    }];

    [getCandyTask resume];
}
#pragma mark - Getter Override

- (NSURLSessionConfiguration *)sessionConfiguration {
    if (!_sessionConfiguration) {
        _sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    
    return _sessionConfiguration;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
