//
//  ViewController.m
//  PasscodeRecovery
//
//  Created by ChenYi on 16/02/2015.
//  Copyright (c) 2015 Yi Chen. All rights reserved.
//

#import "ViewController.h"
#import "KeyChainUtil.h"
#import "ConstantDefinition.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)displayPasscode {
    NSString* encryptKey = [KeyChainUtil loadFromKeyChainForKey:kEncryptKey];
    [_passcodeLabel setText:encryptKey];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayPasscode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
