import QtQuick 2.12
import QtQuick.Dialogs 1.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.11
import QtQuick.LocalStorage 2.15
import QtMultimedia 5.15

ApplicationWindow {
    id: mainWindow
    width: 640
    height: 480
    visible: true
    title: qsTr("MuDeeR Labeler")


    ListModel
    {
        id: listModel
    }

    FileDialog {
        id: fileDialog
        title: "Please choose the database"
        folder: shortcuts.home


        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrl + " in " + fileDialog.folder)
            var db
            db = LocalStorage.openDatabaseSync(fileDialog.fileUrl)
            db.transaction(function(tx) {
                result = tx.executeSql("SELECT * FROM files");
                for (var i = 0; i < results.rows.length; i++) {
                    listModel.append({
                        file: results.rows.item(i).file,
                        text: results.rows.item(i).text,
                        corrected: results.rows.item(i).corrected
                    })
                }

            })
        }

    }

    Audio {
        id: playMusic
    }


    ColumnLayout {
        anchors.fill: parent

        spacing: 5

        Button {
            id: openButton
            text: qsTr("Open Folder")
            onClicked: fileDialog.open()
            Layout.fillWidth: true
            Layout.preferredHeight: 50
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.preferredHeight: 300

            model: listModel

            delegate: Button {
                width: parent.width
                height: 30
                text: file
                onClicked: {
                    playMusic.source = file
                    playMusic.play()
                }
            }
            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
            focus: true
        }


        TextEdit {
            id: textEdit
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: qsTr("Text Edit")
            font.pixelSize: 12
        }
   }


}
