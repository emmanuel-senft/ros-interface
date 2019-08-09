import QtQuick 2.7
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1

import Ros 1.0

Window {

    id: window

    visible: true
    //visibility: Window.FullScreen
    //width: Screen.width
    //height: Screen.height
    width:1200
    height: 800

    ColumnLayout{
        id: intro
        width: parent.width
        height: parent.height
        spacing: height / 6

        TextField{
            id: particpantId
            placeholderText: qsTr("Participant ID")
            text: ""
            focus: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.minimumHeight: 50
            style: TextFieldStyle {
                font.pointSize: 20
                textColor: "black"
                background: Rectangle {
                    radius: 2
                    implicitWidth: 200
                    implicitHeight: 50
                    border.color: "#333"
                    border.width: 1
                }
            }
            onAccepted: globalStates.state = "condition"
        }
        Button{
            id: reset
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.minimumHeight: 100
            Layout.minimumWidth: 200
            height: parent.height/11
            text: "Postition Robot"
            onPressedChanged: {
                if(pressed){
                    publisher.text = "reset-robot"
                }
            }
        }
    }

    Label{
        id: statusMessage
        visible: conditionGrid.visible
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height/10
        text:"Please select a condition"
        font.pixelSize: 40
        color: "steelblue"
    }

    GridLayout{
        id: conditionGrid
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height/2
        width: parent.width/2
        columnSpacing: width/5
        rowSpacing: width/5
        visible: false
        columns: 2
        property int buttonHeight: 100
        property int buttonWidth: 250
        Component {
            id: buttonStyle
            ButtonStyle {
                label: Text {
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: "Helvetica"
                    font.pointSize: 20
                    text: control.text
                    }
                }
        }
        Button{
            id: rotate_slide
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.minimumHeight: conditionGrid.buttonHeight
            Layout.minimumWidth: conditionGrid.buttonWidth
            height: parent.height/11
            text: "Rotate Slide"
            style: buttonStyle
            onPressedChanged: {
                if(pressed){
                    publisher.text = "launch-"+particpantId.text+"-step_slide"
                }
            }
        }
        Button{
            id: rotate_stop
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.minimumHeight: conditionGrid.buttonHeight
            Layout.minimumWidth: conditionGrid.buttonWidth
            height: parent.height/11
            text: "Rotate Stop"
            style: buttonStyle
            onPressedChanged: {
                if(pressed){
                    publisher.text = "launch-"+particpantId.text+"-step_stop"
                }
            }
        }
        Button{
            id: face_slide
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.minimumHeight: conditionGrid.buttonHeight
            Layout.minimumWidth: conditionGrid.buttonWidth
            height: parent.height/11
            text: "Face Slide"
            style: buttonStyle
            onPressedChanged: {
                if(pressed){
                    publisher.text = "launch-"+particpantId.text+"-move_slide"
                }
            }
        }
        Button{
            id: face_stop
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.minimumHeight: conditionGrid.buttonHeight
            Layout.minimumWidth: conditionGrid.buttonWidth
            height: parent.height/11
            text: "Face Stop"
            style: buttonStyle
            onPressedChanged: {
                if(pressed){
                    publisher.text = "launch-"+particpantId.text+"-move_stop"
                }
            }
        }
    }
    Button {
            id: finish
            visible: conditionGrid.visible
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            opacity:1.0
            width: 200
            height: 100
            text: qsTr("Finish")
            style: ButtonStyle {
                    label: Text {
                            renderType: Text.NativeRendering
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            font.pointSize: 20
                            text: finish.text
                    }
            }
            onClicked: { globalStates.state="start" }
    }

    StateGroup {
        id: globalStates
        states: [
            State {
                name: "start"
                StateChangeScript{
                    script: {
                        conditionGrid.visible = false
                        intro.visible = true
                        particpantId.text = ""
                    }
                }
            },
            State {
                name: "condition"
                StateChangeScript{
                          script: {
                              conditionGrid.visible = true
                              intro.visible = false
                          }
                      }
            }

        ]
    }
    RosStringPublisher {
        id: publisher
        topic: "/interaction_commands"
    }
    RosStringSubscriber {
        id: subscriber
        topic: "/interaction_events"
        onTextChanged:{
            if(text === "start"){
                statusMessage.text = "Waiting to go to position"
            }
            if(text === "patroller-waiting"){
                statusMessage.text = "Ready"
            }
            if(text === "planner-stop"){
                statusMessage.text = "Please select a condition"
            }


        }
    }
 }
