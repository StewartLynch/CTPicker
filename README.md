# CTPicker
### What is this?

If you wish to limit your user to picking from an array of strings, then a TableView or UIPicker may meet your needs.  However, as the number of entries grow, these controls may not be very efficient.  In this solution I present the user with a tableView of all options but with a search text field that will filter as you type to zoom in on the preferred value.  If the value is not available, there is also the optional "add" button to allow your users to add to the data source.

### YouTube Video

Watch this video to see installation and use as described below.

TODO: Create video

### Installation

1. From within Xcode 11 or later, choose **File > Swift Packages > Add Package Dependency**
2. At the next screen enter https://github.com/StewartLynch/CTPicker.git when asked to choose a Package repository
3. Choose the latest available version.
4. Add the package to your target.

You now have the dependency installed and are ready to import CTPicker

### Set up?

Setting up to use this solution on one or more of your UITextFields is straight forward.

##### Step 1 - Import CTPicker

In the ViewController where you are going to implement CTPicker on your TextFields, import CTPicker.

```swift
import CTPicker
```

##### Step 2- ViewController Delegates 

The ViewControllers containing your UITextFields must conform to **UITextFieldDelegate** and to **CTPickerDelegate**

The conformance to CTPickerDelegate will require the addition of the **setTextField** delegate function.  More about this below.

```swift
    func setField(value: String, type:CTPickerType, selectedTextField: UITextField, new: Bool) {
        <#code#>
    }
```

##### Step 3 - Create an optional ctPickerDelegate variable

```swift
class ViewController: UIViewController, UITextFieldDelegate, CTPickerDelegate {
    // Required variable
    weak var cTDelegate:CTPickerDelegate?
```



##### Step 4 - Assign viewController to the cTDelegate variable

```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        // You can do this in viewDidLoad
        cTDelegate = self
    }
```

##### Step 5 - Create your UITextFields

In your ViewController, create your UITextFields either programmatically or using Interface Builder.  In each case, the UITextField delegate must be assigned to the ViewController.

```swift
// Must assign the text fields as the UITextFieldDelegates
    varietyTextField.delegate = self
    countryTextField.delegate = self
    wineryTextField.delegate = self
```

##### Step 6 - Implement textFieldDidBeginEditing

Now, when your users tap into the field you want to present the list of values.  The **CTPicker.presentCTPicker** function must be called within the **textFieldDidBeginEditing:** function which is a UITextField delegate function.

No matter what optional style values you choose, you **always** pass ***self*** as the first parameter and ***textField*** as the second one.

The third parameter is the array of strings.  In example shown, I am passing varietyArray, countryArray and wineryArray.

The remaining parameters (except for the last one) are optional and used if you wish to custom style the navigation bar on the picker and the tint color of the action buttons for the 'add' alert or if you wish to have your own custom strings used.  You can choose to include any number of these optional parameters, or none at all.  See the **Optional parameters** section below for more detail.

The final parameter, isAddEnabled, defaults to **false**, which means the array is Read Only.  If you wish to allow your users to add to the list of options, include ***isAddEnabled: true*** as the final parameter.

Here is an example.

```swift
func textFieldDidBeginEditing(_ textField: UITextField) {
  // Dismiss the keyboard immediately
  textField.resignFirstResponder() 
  // Depending on the type of field tapped, pass the viewController, the textField and current array of strings to the presentPickerFunction along with any of the optional parameters
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
    // Default presentation - but ability to add items to the array
      CTPicker.presentCTPicker(on: self,
                    textField: textField,
                    items: wineryArray,
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

### Optional Parameters

As mentioned above there are additional optional parameters that you can pass to the **presentCTPicker** function.  

##### Custom Strings

The first allows you to pass a set of string values that will override  the default set used on the CTPicker navigation bar and on the add new item alert.  To create these strings, first declare an instance of the CTPicker.CTStrings class and enter your custom strings.  If you do not use this option, the default values shown will be used.

```swift
  let ctStrings = CTPicker.CTStrings(pickText: "Tap on a line to select.",
                                     addText: "Tap '+' to add a new entry.",
                                     searchPlaceHolder: "Filter by entering text...",
                                     addAlertTitle: "Add new item",
                                     addBtnTitle: "Add",
                                     cancelBtnTitle: "Cancel")
```

Once you have declared your CTStrings object, you can pass it on to the function as the 4th parameter.
```swift
CTPicker.presentCTPicker(on: self,
                    textField: textField,
                    items: wineryArray,
                    ctStrings: ctStrings,
                    isAddEnabled: true)
```

##### Custom Colors

The final 3 parameters are custom colors that you can pass to the function that will override the default colors used on the CTPicker navigation bar and on the add new item alert.

**Note:** The default colors support **dark mode** if you are using CTPicker on a device running iOS 13 or later.  If you are going to customize the colors, ensure that you include dark mode supported color sets.

These three colors are:

- **navBarBarTintColor** - the background color of the navigation bar
- **navBarTintColor** - the navigation bar button colors
- **actionTintColor** - the alert button colors

To pass these on to the function, you can add these as the 5th, 6th and 7th parameters.  Each one is optional so you may choose to leave one or more out.

Here is an example of a CTPicker.presentCTPicker call using all options.
```swift
 let ctStrings = CTPicker.CTStrings(pickText: "Lorem ipsum dolor sit amet.",
                                    addText: "Consectetur adipiscing elit.",
                                    searchPlaceHolder: "Vivamus ut dignissim dui...",
                                    addAlertTitle: "Excepteur sint occaecat",
                                    addBtnTitle: "Anim",
                                    cancelBtnTitle: "Sund")
 CTPicker.presentCTPicker(on: self,
                          textField: textField,
                          items: wineryArray,
                          ctStrings: ctStrings,
                          navBarBarTintColor: .red,
                          navBarTintColor: .white,
                          actionTintColor: .purple,
                          isAddEnabled: true)
```
