# office-sm-ios-swift-shurjopay-sdk-v2
Office SM iOS Swift shurjoPay SDK V2

# ShurjopaySdk

[![CI Status](https://img.shields.io/travis/shurjoMukhiDev/ShurjopaySdk.svg?style=flat)](https://travis-ci.org/shurjoMukhiDev/ShurjopaySdk)
[![Version](https://img.shields.io/cocoapods/v/ShurjopaySdk.svg?style=flat)](https://cocoapods.org/pods/ShurjopaySdk)
[![License](https://img.shields.io/cocoapods/l/ShurjopaySdk.svg?style=flat)](https://cocoapods.org/pods/ShurjopaySdk)
[![Platform](https://img.shields.io/cocoapods/p/ShurjopaySdk.svg?style=flat)](https://cocoapods.org/pods/ShurjopaySdk)

### GIT Command
```git_command
git init
git remote add origin https://github.com/rzrasel/office-sm-ios-swift-shurjopay-sdk-v2.git
git remote -v
git fetch && git checkout master
git add .
git commit -m "Add Readme & Git Commit File"
git pull
git push --all
git status
git remote show origin
git status
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ShurjopaySdk is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby_podInit
pod init
```

`arch -x86_64` <kbd>arch -x86_64 pod init</kbd>

```ruby_shurjoPaySdk
pod "ShurjopaySdk"
// Or
pod "ShurjopaySdk", "~> 1.0"
```

```ruby_podInstall
pod install
```

`arch -x86_64` <kbd>arch -x86_64 pod install</kbd>

Import package:

```git_request_import
import ShurjopaySdk
```

### Request Data Model Setup:

```git_request_data_model_setup
let requestData = RequestData(
    username:           "username",
    password:           "password",
    prefix:             "prefix",
    currency:           "currency",
    amount:             0,
    orderId:            "orderId",
    discountAmount:     0,
    discPercent:        0,
    customerName:       "customerName",
    customerPhone:      "customerPhone",
    customerEmail:      "customerEmail",
    customerAddress:    "customerAddress",
    customerCity:       "customerCity",
    customerState:      "customerState",
    customerPostcode:   "customerPostcode",
    customerCountry:    "customerCountry",
    returnUrl:          "returnUrl",
    cancelUrl:          "cancelUrl",
    clientIp:           "clientIp",
    value1:             "value1",
    value2:             "value2",
    value3:             "value3",
    value4:             "value4"
)
```

### Response Listener:

```git_response_listener
shurjopaySdk = ShurjopaySdk(onSuccess: onSuccess, onFailed: onFailed)
```

### Payment Request Setup:

```git_payment_request_setup
shurjopaySdk?.makePayment(
    uiProperty:     UIProperty(viewController: self,
                               storyboardName: "Main",
                               identifier: "sPayViewController"),
    sdkType:        AppConstants.SDK_TYPE_SANDBOX,
    requestData:    requestData
)
```
### Response Listener Setup:

```git_response_listener_setup
func onSuccess(transactionData: TransactionData?, message: ErrorSuccess) {
    if(message.esType == ErrorSuccess.ESType.INTERNET_SUCCESS) {
        print("DEBUG_LOG_PRINT: INTERNET SUCCESS \(String(describing: message.message))")
    } else {
        print("DEBUG_LOG_PRINT: HTTP SUCCESS TRANSACTION_DATA: \(String(describing: transactionData)) \(String(describing: message.message))")
    }
}
func onFailed(message: ErrorSuccess) {
    if(message.esType == ErrorSuccess.ESType.INTERNET_ERROR) {
        print("DEBUG_LOG_PRINT: INTERNET ERROR \(String(describing: message.message))")
        //alertService.alert(viewController: self, message: message.message!)
    } else {
        print("DEBUG_LOG_PRINT: HTTP ERROR \(String(describing: message.message))")
    }
}
```

## Author

Rz Rasel

### CocoaPods Trunk
- Trunk Me: <kbd>pod trunk me</kbd>
- Pod Lint: <kbd>pod spec lint [NAME.podspec]</kbd> or `pod lib lint`
- Trunk Register: <kbd>pod trunk register rzrasel@rzrasel.org 'Rz Rasel'</kbd>
- Trunk Push: <kbd>pod trunk push</kbd> or `pod trunk push [NAME.podspec]`
- <kbd></kbd>
- <kbd></kbd>

## License

ShurjopaySdk is available under the MIT license. See the LICENSE file for more info

`Android Studio MacBook Pro:` <kbd>d5N3zwFKoh1k6yVcMSmg2MuC060mkS-hghp_Ec7xmc</kbd>
