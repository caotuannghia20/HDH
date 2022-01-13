import QtQuick 2.0

Item {

    property int time
    property var tasks
    property alias title: queueTitle.text
    property var condition

    Text {
        id: queueTitle
    }

    ListView {
        anchors.top: queueTitle.bottom
        model: tasks.length
        orientation: Qt.Horizontal
        width: 200
        height: 50

        delegate: Rectangle {
            width: 50
            height: 50
            opacity: time * 0 + condition(index) ? 1 : 0
            color: tasks[index].color

            Text {
                anchors.centerIn: parent
                text: time * 0 + tasks[index].remainTime
            }
        }

        Rectangle {
            anchors.fill: parent
            opacity: 0.1
            border {
                color: 'black'
                width: 1
            }
        }
    }
}
