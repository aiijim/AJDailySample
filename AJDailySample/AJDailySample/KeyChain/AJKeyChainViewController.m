//
//  AJKeyChainViewController.m
//  AJDailySample
//
//  Created by aiijim on 2020/4/15.
//  Copyright © 2020 aiijim. All rights reserved.
//

#import "AJKeyChainViewController.h"

@interface AJKeyChainViewController ()<UITextFieldDelegate>

@end

@implementation AJKeyChainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"KeyChain Sample";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField* txtField = [[UITextField alloc] initWithFrame:CGRectMake(20, self.view.bounds.size.height / 3, self.view.bounds.size.width - 40, 36)];
    txtField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    txtField.layer.borderWidth = 1.0;
    txtField.layer.cornerRadius = 5.0;
    txtField.text = [self readPassword];
    txtField.placeholder = @" input password:";
    txtField.delegate = self;
    [self.view addSubview:txtField];
    
    UIBarButtonItem* deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"delete" style:UIBarButtonItemStylePlain target:self action:@selector(deletePassword)];
    self.navigationItem.rightBarButtonItem = deleteItem;
}

- (void)deletePassword {
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge NSString*)kSecClass];
//    [query setObject:@"KeyChainSample" forKey:(__bridge NSString*)kSecAttrAccount];
    [query setObject:@"com.custom.AJDailySample" forKey:(__bridge NSString*)kSecAttrService];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    [self showMessage:status == errSecSuccess ? @"password delete successfully" : @"password delete failed"];
}

- (NSString*)readPassword {
    CFTypeRef result = nil;
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge NSString*)kSecClass];
    [query setObject:@"KeyChainSample" forKey:(__bridge NSString*)kSecAttrAccount];
    [query setObject:@"com.custom.AJDailySample" forKey:(__bridge NSString*)kSecAttrService];
    [query setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge NSString*)kSecReturnData];

    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (status == errSecSuccess && CFGetTypeID(result) == CFDataGetTypeID()) {
        NSData* data = (__bridge_transfer NSData*)result;
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    } else {
        return @"";
    }
}

- (void)savePassword:(NSString*)pwd {
    NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
    [attributes setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge NSString*)kSecClass];
    [attributes setObject:@"KeyChainSample" forKey:(__bridge NSString*)kSecAttrAccount];
    [attributes setObject:@"com.custom.AJDailySample" forKey:(__bridge NSString*)kSecAttrService];
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)attributes, NULL);
    if (status == errSecSuccess) {
        NSDictionary* attributesToUpdate = @{(__bridge NSString*)kSecValueData : [pwd dataUsingEncoding:NSUTF8StringEncoding]};
        status = SecItemUpdate((__bridge CFDictionaryRef)attributes, (__bridge CFDictionaryRef)attributesToUpdate);
        [self showMessage:status == errSecSuccess ? @"password updated successfully" : @"password updated failed"];
    } else if (status == errSecItemNotFound) {
        [attributes setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge NSString*)kSecAttrAccessible];
        [attributes setObject:[pwd dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge NSString*)kSecValueData];

        OSStatus status = SecItemAdd((__bridge CFDictionaryRef)attributes, NULL);
        [self showMessage:status == errSecSuccess ? @"password saved successfully" : @"password saved failed"];
    }
}

- (void)showMessage:(NSString*)msg {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Information" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([textField.text length] > 0) {
        [self savePassword:textField.text];
    }
    return YES;
}

@end
