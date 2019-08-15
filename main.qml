import QtQuick 2.11
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
    property var orders:
        [[1, 3, 0, 2],
        [3, 0, 1, 2],
        [2, 0, 3, 1],
        [1, 2, 0, 3],
        [2, 1, 0, 3],
        [0, 2, 3, 1],
        [0, 3, 1, 2],
        [2, 1, 3, 0],
        [1, 0, 2, 3],
        [2, 3, 0, 1],
        [0, 1, 2, 3],
        [3, 1, 0, 2],
        [3, 1, 2, 0],
        [0, 3, 2, 1],
        [3, 2, 1, 0],
        [0, 2, 1, 3],
        [2, 0, 1, 3],
        [3, 2, 0, 1],
        [3, 0, 2, 1],
        [1, 3, 2, 0],
        [1, 0, 3, 2],
        [1, 2, 3, 0],
        [2, 3, 1, 0],
        [0, 1, 3, 2]]

    property var conditions: ["Rotate Slide","Rotate Stop","Face Slide","Face Stop"]
    property var messages: ["step_slide","step_stop","move_slide","face_stop"]

    ColumnLayout{
        id: intro
        width: parent.width
        height: parent.height
        spacing: height / 6
        Label{
            id: startInfo
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.minimumHeight: 50
            font.pointSize: 20
            text: "Please enter a participant ID"
        }

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
        RowLayout{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            width: parent.width
            height: parent.height
            spacing: width / 2
            Rectangle{
                id: reset
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                width: 250
                height: width
                radius: height
                property var text: "Postition Robot"
                color: "#8000FF00"
                border.color: "black"
                border.width: 5
                MouseArea{
                    anchors.fill: parent
                    onClicked: { publisher.text="reset-robot"
                    startInfo.text= "Robot going to starting position"}
                }
                Label{
                    anchors.fill: parent
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 20
                    text: reset.text
                }
            }
            Rectangle {
                id: park
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                width: 250
                height: width
                radius: height
                property var text: qsTr("Park Robot")
                color: "#80FF0000"
                border.color: "black"
                border.width: 5
                MouseArea{
                    anchors.fill: parent
                    onClicked: { publisher.text="park-robot"
                    startInfo.text = "Robot parking"}
                }
                Label{
                    anchors.fill: parent
                    renderType: Text.NativeRendering
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 20
                    text: park.text
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
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 25
                    border.width: control.activeFocus ? 2 : 1
                    border.color: "#888"

                    radius: 4
                    gradient: Gradient {
                        GradientStop { position: 0 ; color: control.wasPressed ? "#ccc" : "#eee" }
                        GradientStop { position: 1 ; color: control.wasPressed ? "#aaa" : "#ccc" }
                    }
                }
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
            id: button1
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.minimumHeight: conditionGrid.buttonHeight
            Layout.minimumWidth: conditionGrid.buttonWidth
            height: parent.height/11
            text: "Rotate Slide"
            property var message: "launch-"+particpantId.text+"-step_slide"
            property bool wasPressed : false
            style: buttonStyle
            onPressedChanged: {
                if(pressed){
                    startCondition(message)
                    wasPressed = true
                }
            }
        }
        Button{
            id: button2
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.minimumHeight: conditionGrid.buttonHeight
            Layout.minimumWidth: conditionGrid.buttonWidth
            height: parent.height/11
            text: "Rotate Stop"
            property var message: "launch-"+particpantId.text+"-step_slide"
            property bool wasPressed : false
            style: buttonStyle
            onPressedChanged: {
                if(pressed){
                    startCondition(message)
                    wasPressed = true
                }
            }
        }
        Button{
            id: button3
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.minimumHeight: conditionGrid.buttonHeight
            Layout.minimumWidth: conditionGrid.buttonWidth
            height: parent.height/11
            text: "Face Slide"
            property var message: "launch-"+particpantId.text+"-step_slide"
            property bool wasPressed : false
            style: buttonStyle
            onPressedChanged: {
                if(pressed){
                    startCondition(message)
                    wasPressed = true
                }
            }
        }
        Button{
            id: button4
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.minimumHeight: conditionGrid.buttonHeight
            Layout.minimumWidth: conditionGrid.buttonWidth
            height: parent.height/11
            text: "Face Stop"
            property var message: "launch-"+particpantId.text+"-step_slide"
            style: buttonStyle
            onPressedChanged: {
                if(pressed){
                    startCondition(message)
                }
            }
        }
    }
    Button {
            id: finish
            visible: conditionGrid.visible
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height/20
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

    function startCondition(message){
        publisher.text = message
        button1.enabled = false
        button1.opacity = .5
        button2.enabled = false
        button2.opacity = .5
        button3.enabled = false
        button3.opacity = .5
        button4.enabled = false
        button4.opacity = .5
    }

    Rectangle {
            id: stop
            visible: conditionGrid.visible
            anchors.right: parent.right
            anchors.rightMargin: parent.width/20
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height/20
            opacity:1.0
            width: 150
            height: 150
            radius: height
            property var text: qsTr("STOP")
            color: "red"
            border.color: "black"
            border.width: 5
            MouseArea{
                anchors.fill: parent
                onClicked: { publisher.text="stop" }
            }
            Label{
                anchors.fill: parent
                renderType: Text.NativeRendering
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 20
                text: stop.text
            }
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
                        button1.wasPressed = false
                        button2.wasPressed = false
                        button3.wasPressed = false
                        button4.wasPressed = false
                    }
                }
            },
            State {
                name: "condition"
                StateChangeScript{
                          script: {
                              conditionGrid.visible = true
                              intro.visible = false
                              var order = orders[parseInt(particpantId.text)%orders.length]

                              button1.text = conditions[order[0]]
                              button1.message = "launch-"+particpantId.text+"-"+messages[order[0]]
                              button2.text = conditions[order[1]]
                              button2.message = "launch-"+particpantId.text+"-"+messages[order[1]]
                              button3.text = conditions[order[2]]
                              button3.message = "launch-"+particpantId.text+"-"+messages[order[2]]
                              button4.text = conditions[order[3]]
                              button4.message = "launch-"+particpantId.text+"-"+messages[order[3]]
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
            if(text === "patrol-waiting"){
                statusMessage.text = "Ready"
            }
            if(text === "planner-stop"){
                statusMessage.text = "Please select a condition"
                startInfo.text = "Please enter a participant ID"
                button1.enabled = true
                button1.opacity = 1
                button2.enabled = true
                button2.opacity = 1
                button3.enabled = true
                button3.opacity = 1
                button4.enabled = true
                button4.opacity = 1
            }


        }
    }
 }
