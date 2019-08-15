# CTPicker
### What is this?

If you wish to limit your user to picking from an array of strings, then a TableView or UIPicker may meet your needs.  However, as the number of entries grow, these controls may not be very efficient.  In this solution I present the user with a tableView of all options but a search text field that will filter as you type to zoom in on the selected option.  If the value is not available, then there is also the optional "add" button to allow your users to add to the data source.

### YouTube Video

Watch this video to see installation use as described below.

TODO: Create video

### Installation

1. From within Xcode 11 or later, choose **File > Swift Package > Add Package Dependency**
2. At the next screen enter https://github.com/StewartLynch.CTPicker.git when asked to choose a Package repository
3. Choose the latest available version.
4. Add the package to your target.

You now have the dependency installed and are ready to import CTPicker

### Set up?

Setting up to use this solution on one or more of your UITextFields is straight forward.

##### Step 1 - Import CTPicker

In the ViewController where you are going to implement CTPicker on your TextFields, import CTPicker.

**

```swift
import CTPicker
```

##### Step 2- ViewController Delegates 

The ViewControllers containing your UITextFields must conform to **UITextFieldDelegate** and to **CTPickerDelegate**

```swift
class ViewController: UIViewController, UITextFieldDelegate, CTPickerDelegate {
    // Required variable
    weak var cTDelegate:CTPickerDelegate?
}
```

The conformance to CTPickerDelegate will require the addition of the **setTextField** delegate function.  More about this below.

```swift
    func setField(value: String, type:CTPickerType, selectedTextField: UITextField, new: Bool) {
        <#code#>
    }

```

##### Step 3 - Assign viewController to the cTDelegate variable

```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        // You can do this in viewDidLoad
        cTDelegate = self
    }
```

##### Step 4 - Create your UITextFields

In your ViewController, create your UITextFields either programmatically or using Interface Builder.  In each case, the UITextField delegate must be assigned to the ViewController.

```swift
// Must assign the text fields as the UITextFieldDelegates
    varietyTextField.delegate = self
    countryTextField.delegate = self
    wineryTextField.delegate = self
```

##### Step 5 - Call the CTPicker.presentCTPicker function

Now, when your users tap into the field you want to present the list of options.  The presentPicker function must be called within the **textFieldDidBeginEditing:** function which is a UITextField delegate function.

No matter what optional style values you choose, you **always** pass ***self*** as the first parameter and ***textField*** as the second one.

The third parameter is the array of strings.  In this example, I am passing varietyArray, countryArray and wineriesArray

The remaining parameter (except for the last one) are optional and used if you wish to custom style the navigation bar on the picker and the tint color of the action buttons for the 'add' alert.  You can choose to include any number of these optional parameters, or none at all.

The final parameter, isAddEnabled, defaults to **false**, which means the array is Read Only.  If you wish to allow your users to add to the list of options, include ***isAddEnabled: true*** as the final parameter.

```swift
func textFieldDidBeginEditing(_ textField: UITextField) {
  // Dismiss the keyboard immediately
  textField.resignFirstResponder() 
  // Depending on the type of fieled tapped, pass the type, array of items and current array of strings to the presentPickerFunction along with any of the optional parameters
  switch textField {
  case varietyTextField:
      // Default presentation - no adding of items to the array
      CTPicker.presentCTPicker(on: self,
                    textField: textField,
                    items: varietyArray)
  case countryTextField:
      // Default presentation - but ability to add items to the array
      CTPicker.presentCTPicker(on: self,
                    textField: textField,
                    items: countryArray,
                    isAddEnabled: true)
  case wineryTextField:
      // All optional parameters added
      CTPicker.presentCTPicker(on: self,
                    textField: textField,
                    items: wineryArray,
                    navBarBarTintColor: .black,
                    navBarTintColor: .white,
                    navBartitleTextColor: .white,
                    actionTintColor: .black,
                    isAddEnabled: true)
  default:
      break
  }
}
```

##### Step 6 - Handle the selected or added item

Once an item is selected or handled, you must deal with it using the delegate function.

```swift
func setField(value: String, selectedTextField: UITextField, new: Bool) {
  // Assign the selected or new value to the textField
  selectedTextField.text = value
  // if the value is an addition to the array, then you need to append it and update the  datasource if necessary.
  if new {
      switch selectedTextField {
      case countryTextField:
          countryArray.append(value)
      case wineryTextField:
          wineryArray.append(value)
      default:
          break
      }     
  }
}
```

##### 
