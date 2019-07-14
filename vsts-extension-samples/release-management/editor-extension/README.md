# Authoring Task editor extension

## Motivation

Some task inputs can be complex and it might not be the most natural thing for the user to provide the value in the data types currently available to the tasks.
An example would be that your task works with a JSON object with a well-defined schema. You can model the field as *string* or *multiline* in the task today. That works well during execution; however it is not the most intutive experience for the user to provide the input.
In such cases, you can use task editor extension to model the input as a custom UX where user can provide the specific fields of the object. Keep in mind that this is a UX only feature; during execution the task will receive it as a string.

## Authoring the extension

The task editor extension is a [VSTS extension](https://www.visualstudio.com/en-us/docs/integrate/extensions/overview).

The contribution should of type `ms.vss-distributed-task.task-input-editor` and it should target `ms.vss-distributed-task.task-input-editors` contribution.

```JSON
    "contributions":[
        {
            "id": "my-task-editor-extension",
            "type": "ms.vss-distributed-task.task-input-editor",
            "targets": [ "ms.vss-distributed-task.task-input-editors" ],
            "properties": {
                "name": "Editor extension for my custom object",
                "uri": "extension.html"
            }
        }
    ]

```

| Property | Description |
| -------- | ----------- |
| name     | Friendly name of the extension | 
| uri      | URI to the page that hosts the html that loads the extension UX and scripts |

**Javascript sample**

The extension can recieve the current value of all the input fields in the task. It also receives a delegate which can be used to query the content of a file in associated Source Control or Release Artifact. Use "getConfiguration" method on the VSS module to do that. See that.
To return the resulting value when the user presses ok button, the extension needs to register a callback "onOkClicked".

Following sample shows this.

```Typescript
// The class definition of the delegate that can be used to fetch the file contents.
class ITaskEditorExtensionDelegates {
    fileContentProviderDelegate?: (filePath: string, callback: (content: any) => void, errorCallback: (error: any) => void) => void;
}

// Configuration object which the extension gets that represents the current values of all the input fields.
class configuration {
    target: string; // Name of the input which invoked the extension.
    inputValues: { [key: string]: string; }; // values of all the input fields in the task 
    extensionDelegates: ITaskEditorExtensionDelegates;
}

// Get the config and use it populate your UX.
var config: configuration = VSS.getConfiguration();
    
// Register the onOkyClicked callback.
VSS.register(VSS.getContribution().id, (function () {
        return {
            // Called when the active work item is modified
            onOkClicked: function() {
                // Return the value to be used as the task input.
            }
        }
    })());

```
## Refering to the extension in task.json
Once you have authored the extension, you can refer to the extension against an input field by specifying the full extension id in the editorExtension property. See below.

In addition, you can also specify a "displayFormat" template if the value is a JSON object.

```JSON

"inputs": [
    {
        "name": "complexParam",
        "type": "multiLine",
        "properties": {
            "editorExtension": "extensionid",
            "displayFormat": "Configure for user {{userDetails.name}}"
        }
    }
]

In the above example, if the returned value is following, the displayFormat would evaluate to "Configure for user John Doe".
{
    "userDetails":{ 
        "name":"John Doe",
        "address": ""
    },
    "configDetails":{

    }
}

```




