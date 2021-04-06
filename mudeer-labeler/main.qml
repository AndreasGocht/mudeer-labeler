import QtQuick 2.12
import QtQuick.Controls 2.5
import QtMultimedia 5.15
import Qt.labs.platform 1.1
import Qt.labs.folderlistmodel 2.1

ApplicationWindow {
    id: mainWindow
    width: 640
    height: 480
    visible: true
    title: qsTr("MuDeeR Labeler")

    FolderDialog {
        id: folderDialog
        currentFolder: viewer.folder
        folder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]

        onAccepted: {
            console.log("You chose: " + folder)
            fileModel.folder = folder
        }
    }

    Audio {
        id: playMusic
    }


    Column {
        anchors.fill: parent

        spacing: 5
        padding: 10

        Button {
            id: openButton
            text: qsTr("Open Folder")
            onClicked: folderDialog.open()
            width: parent.width
            height: 50
        }

        ListView {
            id: listView
            width: parent.width
            height: (parent.height - openButton.height)*0.45
            model: FolderListModel {
                id: fileModel
                nameFilters: ["*.wav"]
                showDirs: false
            }
            delegate: Button {
                width: parent.width
                height: 30
                text: fileName
                onClicked: {
                    playMusic.source = fileUrl

                    var request = new XMLHttpRequest()
                    request.open('GET', fileUrl + ".txt")
                    request.onreadystatechange = function(event) {
                        if (request.readyState === XMLHttpRequest.DONE) {
                            textEdit.text = request.responseText
                        }
                    }
                    request.send()

                    playMusic.play()
                }
            }
            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
            focus: true
        }


        TextEdit {
            id: textEdit
            width: parent.width
            height: (parent.height - openButton.height)*0.45
            text: qsTr("Text Edit")
            font.pixelSize: 12
        }
   }


}
